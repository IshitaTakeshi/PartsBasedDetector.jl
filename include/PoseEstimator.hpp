#include "Candidate.hpp"
#include "Visualize.hpp"
#include "PartsBasedDetector.hpp"


class PoseEstimator {
  public:
    PoseEstimator(const std::string filename);
    std::vector<Candidate> estimate(const cv::Mat& image);
  private:
    PartsBasedDetector<float> pbd;
};
