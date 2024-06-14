listToMatrix <- function(df) {
        mat <- matrix(0, length(unique(unlist(df[, 2]))), length(unique(unlist(df[, 1]))))
        rownames(mat) <- sort(unique(unlist(df[, 2])))
        colnames(mat) <- sort(unique(unlist(df[, 1])))
        mat[df[, 2:1]] <- as.numeric(df[, 3])
        return(mat)
}
