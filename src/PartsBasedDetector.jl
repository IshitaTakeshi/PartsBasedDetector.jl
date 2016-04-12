# Copyright (C) 2015 Ishita Takeshi

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


module PartsBasedDetector

export Candidate, make_estimator, estimate

const shared_library_path = "../lib/libPartsBasedDetector.so"
const model_path = joinpath(Pkg.dir("PartsBasedDetector"),
                            "models", "PersonINRIA_9parts.xml")

type Point
    x::UInt32
    y::UInt32
end


type CCandidate
    size::UInt32
    parts::Ptr{Ptr{Point}}
    confidence::Ptr{Float32}
end


type CCandidates
    size::UInt32
    candidates::Ptr{Ptr{CCandidate}}
end


type PointerHandler{T}
    """
    Pointer handler
    We need this type since the finalizer function in Julia
    doesn't allow Ptr{Void} type variables.
    """
    pointer::Ptr{T}
end


function pointer_finalizer(handler::PointerHandler, finalizer::Function)
    """
    Finalize a PointerHandler type variable by the finalizer
    """
    if handler.pointer != C_NULL
        finalizer(handler.pointer)
        handler.pointer = C_NULL
    end
end


function destroy_estimator(estimator)
    ccall((:destroy_estimator, shared_library_path),
          Void, (Ptr{Void},), estimator)
end


function make_estimator(model_path = model_path)
    p = ccall((:make_estimator, shared_library_path),
              Ptr{Void}, (Cstring,), model_path)
    estimator = PointerHandler(p)
    finalizer(estimator, x -> pointer_finalizer(x, destroy_estimator))
    return estimator
end


function free_candidates(candidates)
    ccall((:free_candidates, shared_library_path),
          Void, (Ptr{CCandidates},), candidates)
end


function estimate_(estimator::PointerHandler, image_filename)
    p = ccall((:estimate, shared_library_path),
              Ptr{CCandidates}, (Ptr{Void}, Cstring),
              estimator.pointer, image_filename)
    candidates = PointerHandler(p)
    finalizer(candidates, x -> pointer_finalizer(x, free_candidates))
    return candidates
end


function print_candidate(candidate)
    ccall((:print_candidate, shared_library_path),
          Void, (Ptr{CCandidate},), candidate)
end


type Candidate
    size::UInt32
    parts::Array{Int32, 2}
    confidence::Array{Float32}
end


function estimate(estimator::PointerHandler, image_filename; n_candidates = 10)
    function load_parts(candidate)
        array = pointer_to_array(candidate.parts, candidate.size)
        points = Array(UInt32, candidate.size, 2)
        for (i, p) in enumerate(array)
            point = unsafe_load(p)
            points[i, :] = [point.x, point.y]
        end

        return points
    end

    function load_confidence(candidate)
        confidence = pointer_to_array(candidate.confidence, candidate.size)
        return copy(confidence)  # not to share the object with c
    end

    function load_candidate(candidate_pointer)
        candidate = unsafe_load(candidate_pointer)
        parts = load_parts(candidate)
        confidence = load_confidence(candidate)
        Candidate(candidate.size, parts, confidence)
    end

    handler = estimate_(estimator, image_filename)
    c = unsafe_load(handler.pointer)
    candidate_pointers = pointer_to_array(c.candidates, c.size)

    N = min(n_candidates, length(candidate_pointers))
    candidates = Array(Candidate, N)
    for i in 1:N
        candidates[i] = load_candidate(candidate_pointers[i])
    end

    return candidates
end

end
