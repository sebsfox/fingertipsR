#' Indicator metadata
#'
#' Outputs a data frame containing the metadata for selected indicators
#' @inheritParams fingertips_data
#' @examples
#' \dontrun{
#' # Returns metadata for indicator ID 90362 and 1107
#' indicatorIDs <- c(90362, 1107)
#' indicator_metadata(indicatorIDs)
#'
#' # Returns metadata for the indicators within the domain 1000101
#' indicator_metadata(DomainID = 1000101)
#'
#' # Returns metadata for the indicators within the profile with the ID 129
#' indicator_metadata(ProfileID = 129)}
#' @return The metadata associated with each indicator/domain/profile identified
#' @importFrom jsonlite fromJSON
#' @importFrom utils read.csv
#' @family lookup functions
#' @seealso \code{\link{indicators}} for indicator lookups,
#'   \code{\link{profiles}} for profile lookups,
#'   \code{\link{deprivation_decile}} for deprivation lookups and
#'   \code{\link{area_types}} for area types and their parent mappings
#' @export

indicator_metadata <- function(IndicatorID = NULL,
                               DomainID = NULL,
                               ProfileID = NULL) {
        if (!(is.null(IndicatorID))) {
                AllIndicators <- indicators()
                if (sum(AllIndicators$IndicatorID %in% IndicatorID) == 0){
                        stop("IndicatorID(s) do not exist, use indicators() to identify existing indicators")
                }
                path <- "http://fingertips.phe.org.uk/api/indicator_metadata/csv/by_indicator_id?indicator_ids="
                dataurl <- paste0(path,
                                  paste(IndicatorID, collapse = "%2C"))
                indicator_metadata <- read.csv(dataurl)
        } else if (!(is.null(DomainID))) {
                AllProfiles <- profiles()
                if (sum(AllProfiles$DomainID %in% DomainID) == 0){
                        stop("DomainID(s) do not exist, use profiles() to identify existing domains")
                }
                path <- "http://fingertips.phe.org.uk/api/indicator_metadata/csv/by_group_id?group_id="
                indicator_metadata <- data.frame()
                for (Domain in DomainID) {
                        dataurl <- paste0(path, Domain)
                        indicator_metadata <- rbind(read.csv(dataurl),
                                                    indicator_metadata)
                }
        } else if (!(is.null(ProfileID))) {
                AllProfiles <- profiles()
                if (sum(AllProfiles$ProfileID %in% ProfileID) == 0){
                        stop("ProfileID(s) do not exist, use profiles() to identify existing profiles")
                }
                path <- "http://fingertips.phe.org.uk/api/indicator_metadata/csv/by_profile_id?profile_id="
                indicator_metadata <- data.frame()
                for (Profile in ProfileID) {
                        dataurl <- paste0(path, Profile)
                        indicator_metadata <- rbind(read.csv(dataurl),
                                                    indicator_metadata)
                }
        } else {
                stop("One of IndicatorID, DomainID or ProfileID must be populated")
        }
        colnames(indicator_metadata)[colnames(indicator_metadata)=="Indicator.ID"] <- "IndicatorID"
        return(indicator_metadata)
}
