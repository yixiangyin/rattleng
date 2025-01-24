# Generate error matrix of linear model.
#
# Copyright (C) 2024, Togaware Pty Ltd.
#
# License: GNU General Public License, Version 3 (the "License")
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Time-stamp: <Saturday 2024-11-30 21:41:15 +1100 Graham Williams>
#
# Licensed under the GNU General Public License, Version 3 (the "License");
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author: Zheyuan Xu

# Rattle timestamp: TIMESTAMP
#
# References:
#
# @williams:2017:essentials Chapter 7.
# https://survivor.togaware.com/datascience/dtrees.html
# https://survivor.togaware.com/datascience/rpart.html
# https://survivor.togaware.com/datascience/ for further details.

library(rattle)

print("Error matrix for the Linear model (counts)")

# Generate predictions using the Linear model (model_glm) on the dataset 'trds'.
# 'type = "response"' ensures predictions are on the response scale.

error_predic <- predict(model_glm, newdata = trds, type = "response")

# Calculate the error matrix using the rattle::errorMatrix function.
# 'count = TRUE' produces an error matrix in terms of raw counts.

linear_cem <- rattle::errorMatrix(trds[[target]], error_predic, count = TRUE)

print(linear_cem)

print('Error matrix for the Linear model (proportions)')

# Calculate the error matrix using rattle::errorMatrix without the 'count' argument.
# Produces an error matrix expressed in proportions instead of raw counts.

linear_per <- rattle::errorMatrix(trds[[target]], error_predic)

print(linear_per)
