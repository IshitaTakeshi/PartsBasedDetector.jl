#include <cstdio>
#include <iostream>
#include <boost/scoped_ptr.hpp>
#include <boost/filesystem.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

#include "MatlabIOModel.hpp"
#include "PoseEstimator.hpp"

using namespace std;


PoseEstimator::PoseEstimator(string filename) {
  string ext = boost::filesystem::path(filename).extension().string();
  assert(ext.compare(".mat") == 0);

  boost::scoped_ptr<Model> model;
  model.reset(new MatlabIOModel);

  pbd.distributeModel(*model);
}


//cv::Mat copyPixelArrayToMat(int[][][] pixelArray, int rows, int cols) {
//  const cv::Mat& image(rows, cols, CV_8UC3);
//  for(int y = 0; y < image.rows; y++){
//    for(int x = 0; x < image.cols; x++){
//      image.data[image.step[0]*y + image.step[1]* x + 0] = pixelArray[y][x][0];
//      image.data[image.step[0]*y + image.step[1]* x + 1] = pixelArray[y][x][1];
//      image.data[image.step[0]*y + image.step[1]* x + 2] = pixelArray[y][x][2];
//    }
//  }
//  return image;
//}


////TODO candidate to points of parts considering invisible points
//vector<Candidate> PoseEstimator::estimate(int[][][] pixelArray,
//                                          int rows, int cols) {
//  ///3D pixelArray to cv::Mat
//  cv::Mat& image = copyPixelArrayToMat(pixelArray, rows, cols);
//  //TODO show image once here
//
//  vector<Candidate> candidates;
//  pbd.detect(image, candidates);
//
//  return candidates;
//}
