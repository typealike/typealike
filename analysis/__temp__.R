

    ## must be installed
    library(ez)

    df = read.csv("__temp__.csv")

    # force categorical
    df$ParticipantId = as.factor(df$ParticipantId)

    df$orientation = as.factor(df$orientation)


    # run anoval
    ezANOVA(data = df,
                dv = score,
                wid = ParticipantId,
                within = orientation)

    
        pairwise.t.test(df$score, df$orientation, p.adj="holm", paired=T)
        