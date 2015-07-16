#include <iostream>
#include <cstdio>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <boost/scoped_ptr.hpp>
#include <boost/filesystem.hpp>
#include "MatlabIOModel.hpp"
#include "PoseEstimator.hpp"

using namespace cv;
using namespace std;

int main(int argc, char** argv) {
  assert(argc >= 2);
  PoseEstimator estimator(argv[1]);
}
