# Dev script to quickly diagnose the 'many-to-many' issue when joining data

# STATUS
## Got function to work for simple dummy case!
## Need to make some more tests to test edges

# Load needed libraries
librarian::shelf(dplyr, magrittr)

# Clear environment
rm(list = ls()); gc()

# Make fake data
(df1 <- data.frame("site" = c("x", "x", "x"), "plot" = c(1, 1, 2), "num" = c(5, 6, 4)))
(df2 <- data.frame("site" = c("x", "x", "x"), "plot" = c(1, 1, 2), "treat" = c("burn", "graze", "burn")))

# Join 'em
## Does get warning
(df_join <- dplyr::left_join(x = df1, y = df2, by = c("site", "plot"),
    relationship = "many-to-many"))

# Define function
diagnose_manymany <- function(x = NULL, y = NULL, keys = NULL, join_type = "left"){

    # DELETE ME (vv)
    x = df1; y = df2; keys = c("site", "plot"); join_type = "left"
    # DELETE ME (^^)

    # Error checks for 'keys'
    if(is.null(keys) || is.character(keys) != TRUE)
        stop("'keys' must be provided as a character vector")

    # Error checks for 'x'
    if(is.null(x) || any(!keys %in% names(x)))
        stop("'x' must be provided and have all 'keys' as column names")

    # Error checks for 'y'
    if(is.null(y) || any(!keys %in% names(y)))
        stop("'y' must be provided and have all 'keys' as column names")

    # Error checks for 'join'
    if(is.null(join_type) || is.character(join_type) != TRUE || length(join_type) != 1 || !join_type %in% c("left", "right", "full", "inner"))
        stop("'join_type' must be one of 'left', 'right', 'full', or 'inner' (case-sensitive)")
    
    # Join raw data in way that replicates user's relationship warning
    join_raw <- do.call(what = paste0(join_type, "_join"),
        args = list("x" = x,
            "y" = y,
            "by" = keys,
            "relationship" = "many-to-many"))

    # Summarize both datasets by join keys
    x_simp <- x %>% 
        dplyr::group_by(dplyr::across(dplyr::all_of(x = keys))) %>% 
        dplyr::summarize(.row.count.x = dplyr::n(),
            .groups = "drop")
    y_simp <- y %>% 
        dplyr::group_by(dplyr::across(dplyr::all_of(x = keys))) %>% 
        dplyr::summarize(.row.count.y = dplyr::n(),
            .groups = "drop")

    # Summarize raw joined data to count rows per join key combination
    join_simp <- join_raw %>% 
        dplyr::group_by(dplyr::across(dplyr::all_of(x = keys))) %>% 
        dplyr::summarize(.row.count.join = dplyr::n(),
            .groups = "drop")
    
    # Join all three simplified files and process to become a useful diagnostic
    result <- dplyr::full_join(x = join_simp, y = x_simp, by = keys) %>% 
        dplyr::full_join(x = ., y = y_simp, by = keys) %>% 
        dplyr::filter(.row.count.join != .row.count.x | .row.count.join != .row.count.y)

    # Return that diagnostic
    return(result) }

# Invoke function
diagnose_manymany(x = df1, y = df2, keys = c("site", "plot"))

