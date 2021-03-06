library(testthat)
library(fingertipsR)

context("fingertips data extract")

df1 <- fingertips_data(IndicatorID = 92309)
df2 <- suppressWarnings(fingertips_data(IndicatorID = 92309, DomainID = 1938133055))
df3 <- suppressWarnings(fingertips_data(IndicatorID = 92309, ProfileID = 8))

test_that("the data returned are the same despite different inputs", {
        expect_equal(df1, df2)
        expect_equal(df1, df3)
        expect_equal(ncol(df1), 21)
})

test_that("warning messages work", {
        expect_warning(fingertips_data(IndicatorID = 92309, DomainID = 1938133055),
                       "IndicatorID is complete so DomainID and/or ProfileID inputs are ignored")
        expect_warning(fingertips_data(DomainID = 1938133055, ProfileID = 8),
                       "DomainID is complete so ProfileID is ignored")
        expect_warning(fingertips_data(IndicatorID = 92309, AreaTypeID = 102, ParentAreaTypeID = 101),
                       "AreaTypeID not a child of ParentAreaTypeID\\. There may be duplicate values in data\\. Use function area_types\\(\\) to see mappings of area type to parent area type.")
})

test_that("error messages work", {
        expect_error(fingertips_data(), "One of IndicatorID, DomainID or ProfileID must have an input")
        expect_error(fingertips_data(IndicatorID = 92309, AreaTypeID = "hello"),
                     "Invalid AreaTypeID\\. Use function area_types\\(\\) to see what values can be used\\.")
        expect_error(fingertips_data(IndicatorID = 92309, AreaTypeID = NULL),
                     "AreaTypeID must have a value\\. Use function area_types\\(\\) to see what values can be used\\.")
})
