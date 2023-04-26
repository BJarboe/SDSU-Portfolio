#include "promotedCarModelStack.h"

/**
   * @author Bryce Jarboe, RedID 825033151
   * 
   * @brief push operation, pushing the latest promoted model onto the stack
            Both time and auxiliary space complexity need to be O(1) 
   * @param model 
   * @param price 
   */
void PromotedCarModelStack::push(string model, int price) {
  
  PromotedModel pushModel(model, price);                                                                  //Instantiate the new model to push w/ parameters
  
  promoStack.push_back(pushModel);                                                                                  //add the model to the main stack
  
  pair<PromotedModel, PromotedModel> pushPair;                                                                                  //Instantiate a new pair for the trackStack

  
  if (trackStack.empty()){                                                                       //if the stack was empty, both the minimum and maximum are the new pushed model
    pushPair = make_pair(pushModel, pushModel);
  }
  else{                                                                                                                //else, perform condition checks to properly push the trackStack
    
    if (pushModel.getPromotedPrice() < trackStack.back().first.getPromotedPrice()){                //if the new price is less than the minimum (first), replace the min and preserve the max
      pushPair = make_pair(pushModel, trackStack.back().second);
    }

    else if (pushModel.getPromotedPrice() > trackStack.back().second.getPromotedPrice()){          //if the new price is more than the maximum (second), preserve the min and replace the max
      pushPair = make_pair(trackStack.back().first, pushModel);
    }

    else{                                                                                           //if the new price is falls between the maximum and minimum, preserve both the min and max
      pushPair = make_pair(trackStack.back().first, trackStack.back().second);
    }
  }

  trackStack.push_back(pushPair);                                                                        //push the pair to the top of trackStack

}

/**
   * @brief pop operation, popping the latest promoted model off the stack
            Both time and auxiliary space complexity need to be O(1) 
   * @param  
   * @return PromotedModel
   */
PromotedModel PromotedCarModelStack::pop() {

//throw an exception if the stack has no data
  if (promoStack.empty()){
    throw logic_error("Promoted car model stack is empty");
  }

  PromotedModel poppedModel = promoStack.back();                                         //Instantiate a temporary PromotedModel to be returned

  promoStack.pop_back();                                                               //Remove top of the stack
  trackStack.pop_back();                                                                             //Remove top of the trackStack

  return poppedModel;
}

/**
   * @brief peek operation, peeking the latest promoted model at the top of the stack (without popping)
            Both time and auxiliary space complexity need to be O(1) 
   * @param 
   * @return PromotedModel
   */
PromotedModel PromotedCarModelStack::peek() {
  
  //throw an exception if the stack has no data
  if (promoStack.empty()){
    throw logic_error("Promoted car model stack is empty");
  }
  
  
  //return the top of the stack without modification
  return promoStack.back();
}

/**
   * @brief getHighestPricedPromotedModel, 
   *        getting the highest priced model among the past promoted models
            Both time and auxiliary space complexity need to be O(1)
   * @param 
   * @return PromotedModel
   */
PromotedModel PromotedCarModelStack::getHighestPricedPromotedModel() {

//throw an exception if the stack has no data
  if (promoStack.empty()){
    throw logic_error("Promoted car model stack is empty");
  }

//return the maximum (second) of the top pair of the trackStack
  return trackStack.back().second;
}

/**
   * @brief getLowestPricedPromotedModel, 
   *        getting the lowest priced model among the past promoted models
            Both time and auxiliary space complexity need to be O(1)
   * @param 
   * @return PromotedModel
   */
PromotedModel PromotedCarModelStack::getLowestPricedPromotedModel() {

//throw an exception if the stack has no data
  if (promoStack.empty()){
    throw logic_error("Promoted car model stack is empty");
  }

//return the minimum (first) of the top pair of the trackStack
  return trackStack.back().first;
}