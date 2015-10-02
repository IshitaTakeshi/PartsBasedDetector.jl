import Images: data, raw, Gray


function imcrop(image, box)
    (left, right, top, bottom) = box
    image = slice(image, left:right, top:bottom)
    Image(image)
end

