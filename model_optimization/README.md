# Model Optimization
Machine learning model parameter optimization methods

<hr>

## 1. Basic Idea - Model Performance: ROC curve

<p align="center"><img src="./images/prob_distribution_and_ROC.gif" width="600px"><br/>Ideally, a ML classification algorithm would improve its parameters θ over time via training, resulting in greater predictive power, namely, a cleaner separation of the y probability distributions of True Positive vs. True Negative, given X's (<a href="http://arogozhnikov.github.io/2015/10/05/roc-curve.html">website reference</a>)</p>

<hr>

## 2. Cost Function

Importantly, <a href="./cost.md">a cost function</a> connects the algorithm's θ with its prediction loss (error), just like how a person (the optimization method) trying to walk down to the bottom in an error mountain/surface* (the higher the altitude the greater the error) could translate the current thinking (θ) in a thought path (θ's) to the corresponding altitude (the loss/error).

<p align="center"><a href="./cost.md"><b>J(θ)</b></a></p>

<hr>

## 3. <a href="https://en.wikipedia.org/wiki/Gradient_descent">Gradient Descent</a>

A **first-order** (namely, a method that requires at least one first-derivative/gradient) iterative **optimization** method that finds the weights or coefficients that reach a local minimum of a differentiable function, <a href="./cost.md">the error/cost function, J(θ)</a>

#### Step #1: The model makes predictions on training data using some ballpark θ and a given algorithm.
#### Step #2: The model calculates the <a href="./cost.md">error/loss</a>, which is a way to quantify how good the predictions are.
#### Step #3: The model tries to minimize the <a href="./cost.md">error/loss</a>, which can be expressed as a function of its parameters θ via a <a href="./cost.md">cost function J(θ)</a>, by adjusting θ so that error/loss can be reduced along the gradient (slope) of the cost function.

Analogy | Gradient Descent
--- | ---
1.&nbsp;A person, who is stuck in the mountain and trying to get down | the optimization method, which is somewhere in the errors surface and trying to find θ that globally minimizes J(θ)
2.&nbsp;Path taken down the mountain | the sequence of θ parameters (coefficients or weights) that the algorithm will explore
3.&nbsp;The steepness of the hill (the direction to travel is the steepest descent) | the slope/gradient of J(θ) with respect to θ
4.&nbsp;The instrument used to measure steepness | differentiation of the cost function, the **partial derivative of J(θ) with respect to θ**
5.&nbsp;The amount of time they travel before taking another measurement | the learning rate of the algorithm, α
6.&nbsp;The altitude of the person's location | the error the model makes when predicting on training data, J(θ)

<p align="center"><img src="./images/gradient_descent.png" width="500px"></p>

<hr>

#### Descriptions:

Approach | Details
--- | ---
Batch | - Calculates the error for each example in the training dataset, but only updates the model after **the entire training set** has been evaluated.<br/>- If there are 5 millions examples, we need to sum the 5-million errors every epoch.<br/>- One cycle through the entire training set is called a training epoch.<br/>- When we refer to gradient descent, we typically mean the batch gradient descent.
<a href="https://www.geeksforgeeks.org/ml-stochastic-gradient-descent-sgd/?ref=lbp">Stochastic</a> (SGD) | - Instead of using the entire training set every time, use **just 1 example**<br/>- Before for-looping, randomly shuffle the training examples.
<a href="https://www.geeksforgeeks.org/ml-mini-batch-gradient-descent-with-python/">Mini-Batch</a> | - The common ground between batch and SGD.<br/>- Use **n data points** (instead of just 1 example in SGD) at each iteration.<br/>- It is the most common implementation of gradident descent in the field of deep learning.

<hr>

#### Comparisons:

Approach | Pros | Cons | Implementation
--- | --- | --- | ---
Batch | - More stable convergence | - May have local minimum<br/>- Very slow for large data sets<br/>- Take a lot of memory | ---
Stochastic (SGD) | - Faster learning for large data sets<br/>- May avoid local minimum due to the noise | - Harder to converge<br/>- Higher variance | <a href="https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.SGDClassifier.html#sklearn.linear_model.SGDClassifier">sklearn.linear_model.SGDClassifier</a>
Mini-Batch | - More robust convergence than batch by avoiding local minimum<br/>- Take less memory than batch<br/> | - Need to specify n (mini-batch size, usually 32) | <a href="https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.SGDClassifier.html#sklearn.linear_model.SGDClassifier">sklearn.linear_model.SGDClassifier</a>.partial_fit()

<hr>

## 4. Gradient Descent Example: Batch gradient descent -- logistic regression with two features

Dataset | Learning rate α | Number of iterations (epochs) | Decision Boundary | Training Loss, <a href="./cost.md">J(θ)</a>, vs. epoch
--- | --- | --- | --- | ---
Binarized iris* | 0.1 | 300 | <img src="./batch_gradient_descent/images/data=iris_logistic_regression_two_features_decision_boundary_animation_learning=0.1_epochs=300.gif" width="450px"> | <img src="./batch_gradient_descent/images/data=iris_logistic_regression_two_features_loss_vs_epoch_learning=0.1_epochs=300.png" width="400px">
Binarized iris* | 0.5 | 300 | <img src="./batch_gradient_descent/images/data=iris_logistic_regression_two_features_decision_boundary_animation_learning=0.5_epochs=300.gif" width="450px"> | <img src="./batch_gradient_descent/images/data=iris_logistic_regression_two_features_loss_vs_epoch_learning=0.5_epochs=300.png" width="400px">
Gender | 0.00025 | 300 | <img src="./batch_gradient_descent/images/data=gender_logistic_regression_two_features_decision_boundary_animation_learning=0.00025_epochs=300.gif" width="450px"> | <img src="./batch_gradient_descent/images/data=gender_logistic_regression_two_features_loss_vs_epoch_learning=0.00025_epochs=300.png" width="400px">
Gender | 0.001 | 300 | <img src="./batch_gradient_descent/images/data=gender_logistic_regression_two_features_decision_boundary_animation_learning=0.001_epochs=300.gif" width="450px"> | <img src="./batch_gradient_descent/images/data=gender_logistic_regression_two_features_loss_vs_epoch_learning=0.001_epochs=300.png" width="400px">

\*statsmodel.Logit() cannot be used to estimate coefficients here, due to "Perfect separation detected, results not available". This speaks to the importance of using gradient descent method.<br/>

References:
- My own <a href="./batch_gradient_descent/logistic_regression_two_features.py">Python code</a> that produced the results
- For animations techniques, please see <a href="./batch_gradient_descent/animation.py">python</a> and <a href="./batch_gradient_descent/animation.ipynb">ipynb</a>

<hr>

## 5. Other Python code examples

```python3
def Batch_Gradient_Descent(X, y, theta0, alpha, num_iters): # for linear regression
    """
       Performs gradient descent to learn theta
    """
    m = y.size  # number of training examples
    theta = theta0
    for i in range(num_iters):
        y_hat = np.dot(X, theta)
        gradient = (1.0/m) * np.dot(X.T, y_hat-y)
        theta = theta - (alpha * gradient)
    return theta
    
def Stochastic_Gradient_Descent(f_derivative, theta0, alpha, num_iters): # A general case
    """ 
       Arguments:
       f_derivate -- the function to optimize, it takes a single argument
                     and yield two outputs, a cost and the gradient
                     with respect to the arguments
       theta0 -- the initial point to start SGD from
       num_iters -- total iterations to run SGD for
       Return:
       theta -- the parameter value after SGD finishes
    """
    start_iter = 0
    theta = theta0
    for iter in xrange(start_iter + 1, num_iters + 1):
        _, gradient = f_derivate(theta)
        theta = theta - (alpha * gradient)
    return theta
    
# reference: https://towardsdatascience.com/difference-between-batch-gradient-descent-and-stochastic-gradient-descent-1187f1291aa1
```

<hr>

## 6. Mini-Batch Gradient Descent in Python

Python <a href="./mini_batch_GD_logistic_regression.py">code</a>

<img src="./images/mini_batch_GD_logistic_regression_graph1.png" width="450px"><img src="./images/mini_batch_GD_logistic_regression_graph2.png" width="450px">

<hr>

## 7. Visualization of Different Optimizers

<p align="center"><img src="./images/visualization_of_optimization_methods.gif" width="500px"><br/>(<a href="https://towardsdatascience.com/why-visualize-gradient-descent-optimization-algorithms-a393806eee2">image source</a>; also see <a href="https://github.com/ilguyi/optimizers.numpy">here</a>)</p>

References:
- <a href="https://www.geeksforgeeks.org/ml-momentum-based-gradient-optimizer-introduction/?ref=lbp">Momentum-based</a> gradient optimizer
- <a href="https://www.geeksforgeeks.org/ml-xgboost-extreme-gradient-boosting/?ref=lbp">eXtreme Gradient Boosting</a>
- <a href="http://www.oranlooney.com/post/ml-from-scratch-part-2-logistic-regression/">Nesterov Accelerated Gradient</a> (NAG)
- <a href="https://machinelearningmastery.com/adam-optimization-algorithm-for-deep-learning/">Adam</a> Optimizer (also introduction of AdaGrad and RMSProp)
