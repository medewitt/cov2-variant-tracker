library(data.table)
library(magrittr, include.only = '%>%')

dat <- data.table::fread(file.path("data", "helix-latest.csv"))

nc_all = dat[state=="NC"][,t:=.I]

fit <- glm(cbind(all_SGTF,positive ) ~ t, family = binomial, data = nc_all)
summary(fit)
plot(fit)
plot(nc_all$all_SGTF/nc_all$positive, type = "l")

likely_rate = predict(fit, newdata = data.frame(t = 1:200), type = "response")

prediction_out = data.frame(date = seq.Date(min(nc_all$collection_date),
                                            Sys.Date()+60, by = "day")) %>%
  setDT() %>%
  .[,t:=.I]
prediction_out$pred = predict(fit, newdata = prediction_out, type = "response")
prediction_out$se = predict(fit, newdata = prediction_out, type = "response", se.fit = TRUE)$se.fit
prediction_out[, pred_lo := pred - 2 * se]
prediction_out[, pred_hi := pred + 2 * se]


save_figs = TRUE
if (save_figs) pdf(file.path("output", "sgtf-nc-helix.pdf"), height=8, width=10, colormodel="gray")
par(mar=c(4,3,2,2), mgp=c(1.5, .5, 0), tck=-.01)
plot(pred*100~date, data = prediction_out,
     ylab = "% of Circulating Strains", xlab = '', type = "l")
lines(prediction_out$date, prediction_out$pred_lo*100, type = "l", lty = 2)
lines(prediction_out$date, prediction_out$pred_hi*100, type = "l", lty = 2)
title("Estimated Proportion of B.1.1.7 Circulating in North Carolina", adj = 0)
abline(v = Sys.Date(), lty = 2, col = "orange")
text(x = Sys.Date()-10, y = prediction_out[date==Sys.Date()]$pred*100,
     label = sprintf("%s%%\n(%s-%s%%)", round(prediction_out[date==Sys.Date()]$pred*100),
                     round(prediction_out[date==Sys.Date()]$pred_lo*100),
                     round(prediction_out[date==Sys.Date()]$pred_hi*100)))
mtext(side = 1, text = "Logistic Model using Helix SGTF Data", line = 3, adj = 1)
if (save_figs) dev.off()

