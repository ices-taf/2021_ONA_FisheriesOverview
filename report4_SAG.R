
library(icesTAF)
library(icesFO)
library(sf)
library(ggplot2)
library(dplyr)

## Run utilies
source("bootstrap/utilities.r")

# set values for automatic naming of files:
cap_year <- 2021
cap_month <- "November"
ecoreg_code <- "ONA"
ecoreg <- "ONA"
##########
#Load data
##########

trends <- read.taf("model/trends.csv")
catch_current <- read.taf("model/catch_current.csv")
catch_trends <- read.taf("model/catch_trends.csv")

clean_status <- read.taf("data/clean_status.csv")

#set year and month for captions:
cap_month = "November"
cap_year = "2021"
# set year for plot calculations

year = 2021


###########
## 3: SAG #
###########

#~~~~~~~~~~~~~~~#
# A. Trends by guild
#~~~~~~~~~~~~~~~#

unique(trends$FisheriesGuild)

# 1. Demersal
#~~~~~~~~~~~
plot_stock_trends(trends, guild="demersal", cap_year, cap_month , return_data = FALSE)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_Trends_demersal", ext = "png", dir = "report"),  width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="demersal", cap_year , cap_month, return_data = TRUE)
write.taf(dat, file = file_name(cap_year,ecoreg_code,"SAG_Trends_demersal", ext = "csv", dir = "report"))

# 2. Pelagic
#~~~~~~~~~~~
plot_stock_trends(trends, guild="pelagic", cap_year, cap_month , return_data = FALSE)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_Trends_pelagic", ext = "png", dir = "report"), width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="pelagic", cap_year, cap_month, return_data = TRUE)
write.taf(dat,file =file_name(cap_year,ecoreg_code,"SAG_Trends_pelagic", ext = "csv", dir = "report"))

# 3. Benthic
#~~~~~~~~~~~
plot_stock_trends(trends, guild="benthic", cap_year, cap_month ,return_data = FALSE )
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_Trends_benthic", ext = "png", dir = "report"),  width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="benthic", cap_year , cap_month , return_data = TRUE)
write.taf(dat, file =file_name(cap_year,ecoreg_code,"SAG_Trends_benthic", ext = "csv", dir = "report"))

# 4. Elasmobranch
#~~~~~~~~~~~
plot_stock_trends(trends, guild="elasmobranch", cap_year, cap_month ,return_data = FALSE )
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_Trends_elasmobranch", ext = "png", dir = "report"),  width = 178, height = 130, units = "mm", dpi = 300)

dat <- plot_stock_trends(trends, guild="elasmobranch", cap_year , cap_month , return_data = TRUE)
write.taf(dat, file =file_name(cap_year,ecoreg_code,"SAG_Trends_elasmobranch", ext = "csv", dir = "report"))

# 5. Crustacean
#~~~~~~~~~~~
# plot_stock_trends(trends, guild="crustacean", cap_year, cap_month ,return_data = FALSE )
# ggplot2::ggsave(paste0(year_cap, "_", ecoreg, "_FO_SAG_Trends_crustacean.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
# 
# dat <- plot_stock_trends(trends, guild="crustacean", cap_year , cap_month , return_data = TRUE)
# write.taf(dat, file =paste0(year_cap, "_", ecoreg, "_FO_SAG_Trends_crustacean.csv"), dir = "report" )
# 

#~~~~~~~~~~~~~~~~~~~~~~~~~#
# Ecosystem Overviews plot
#~~~~~~~~~~~~~~~~~~~~~~~~~#
guild <- read.taf("model/guild.csv")
trends <- read.taf("model/trends.csv")

# For this EO, they need separate plots with all info

guild2 <- guild %>% filter(Metric == "F_FMSY")
plot_guild_trends(guild, cap_year, cap_month,return_data = FALSE )
guild2 <- guild2 %>% filter(FisheriesGuild != "MEAN")
plot_guild_trends(guild2, cap_year , cap_month,return_data = FALSE )
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"EO_SAG_GuildTrends_F", ext = "png", dir = "report"),  width = 178, height = 130, units = "mm", dpi = 300)
# ggplot2::ggsave(paste0(year_cap, "_", ecoreg, "_EO_SAG_GuildTrends_F.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)
# ggplot2::ggsave("2019_BtS_EO_GuildTrends_noMEAN_F.png", path = "report/", width = 178, height = 130, units = "mm", dpi = 300)

guild2 <- guild %>% filter(Metric == "SSB_MSYBtrigger")
guild3 <- guild2 %>% dplyr::filter(FisheriesGuild != "MEAN")
guild3 <- guild3 %>% filter(Year > 1980)
plot_guild_trends(guild3, cap_year, cap_month,return_data = FALSE )
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"EO_SAG_GuildTrends_SSB", ext = "png", dir = "report"),  width = 178, height = 130, units = "mm", dpi = 300)
# ggplot2::ggsave(paste0(year_cap, "_", ecoreg, "_EO_SAG_GuildTrends_SSB.png"), path = "report/", width = 178, height = 130, units = "mm", dpi = 300)


dat <- plot_guild_trends(guild, cap_year, cap_month ,return_data = TRUE)
write.taf(dat, file = file_name(cap_year,ecoreg_code,"EO_SAG_GuildTrends", ext = "csv", dir = "report"))
# write.taf(dat, file =paste0(year_cap, "_", ecoreg, "_EO_SAG_GuildTrends.csv"), dir = "report" )

dat <- trends[,1:2]
dat <- unique(dat)
dat <- dat %>% filter(StockKeyLabel != "MEAN")
dat2 <- sid %>% select(c(StockKeyLabel, StockKeyDescription))
dat <- left_join(dat,dat2)
write.taf(dat, file = file_name(cap_year,ecoreg_code,"EO_SAG_SpeciesGuildList", ext = "csv", dir = "report"), quote = TRUE)
# write.taf(dat, file =paste0(year_cap, "_", ecoreg, "_EO_SAG_SpeciesGuildList.csv"), dir = "report", quote = TRUE )

#~~~~~~~~~~~~~~~#
# B.Current catches
#~~~~~~~~~~~~~~~#

# 1. Demersal
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "demersal", caption = TRUE, cap_year, cap_month, return_data = FALSE)
catch_current <- catch_current %>% filter(StockKeyLabel != "ele.2737.nea")
bar <- plot_CLD_bar(catch_current, guild = "demersal", caption = TRUE, cap_year, cap_month, return_data = FALSE)
bar_dat <- plot_CLD_bar(catch_current, guild = "demersal", caption = TRUE, cap_year , cap_month , return_data = TRUE)
write.taf(bar_dat, file = file_name(cap_year,ecoreg_code,"SAG_Current_demersal", ext = "csv", dir = "report"))
# write.taf(bar_dat, file =file_name(cap_year,ecoreg_code,"SAG_Current_demersal", ext = "csv"), dir = "report" )

kobe <- plot_kobe(catch_current, guild = "demersal", caption = TRUE, cap_year , cap_month , return_data = FALSE)
#kobe_dat is just like bar_dat with one less variable
#kobe_dat <- plot_kobe(catch_current, guild = "Demersal", caption = T, cap_year , cap_month , return_data = TRUE)

#Check this file name

png(file_name(cap_year,ecoreg_code,"SAG_Current_demersal", ext = "png", dir = "report"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "demersal")
dev.off()

# 2. Pelagic
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "pelagic", caption = TRUE, cap_year, cap_month , return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current, guild = "pelagic", caption = TRUE, cap_year , cap_month , return_data = TRUE)
write.taf(bar_dat, file = file_name(cap_year,ecoreg_code,"SAG_Current_pelagic", ext = "csv", dir = "report"))
# write.taf(bar_dat, file = file_name(cap_year,ecoreg_code,"SAG_Current_pelagic", ext = "csv"), dir = "report")

catch_current <- unique(catch_current)
kobe <- plot_kobe(catch_current, guild = "pelagic", caption = TRUE, cap_year , cap_month , return_data = FALSE)
#check this file name
png(file_name(cap_year,ecoreg_code,"SAG_Current_pelagic", ext = "png", dir = "report"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "pelagic")
dev.off()


# 3. Benthic
#~~~~~~~~~~~
# catch_current$Status[which(catch_current$StockKeyLabel == "sol.27.20-24")] <- "GREEN"

bar <- plot_CLD_bar(catch_current, guild = "benthic", caption = TRUE, cap_year , cap_month , return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current, guild = "benthic", caption = TRUE, cap_year , cap_month , return_data = TRUE)
write.taf(bar_dat, file = file_name(cap_year,ecoreg_code,"SAG_Current_benthic", ext = "csv", dir = "report"))
# write.taf(bar_dat, file =file_name(cap_year,ecoreg_code,"SAG_Current_benthic", ext = "csv"), dir = "report" )

kobe <- plot_kobe(catch_current, guild = "benthic", caption = TRUE, cap_year , cap_month , return_data = FALSE)
#check this file name
png(file_name(cap_year,ecoreg_code,"SAG_Current_benthic", ext = "png", dir = "report"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "benthic")
dev.off()

# 4. Elasmobranch
#~~~~~~~~~~~
# catch_current$Status[which(catch_current$StockKeyLabel == "sol.27.20-24")] <- "GREEN"

bar <- plot_CLD_bar(catch_current, guild = "elasmobranch", caption = TRUE, cap_year , cap_month , return_data = FALSE)
catch_current <- catch_current %>% filter(StockKeyLabel != "syt.27.67")
bar <- plot_CLD_bar(catch_current, guild = "elasmobranch", caption = TRUE, cap_year , cap_month , return_data = FALSE)
bar_dat <- plot_CLD_bar(catch_current, guild = "elasmobranch", caption = TRUE, cap_year , cap_month , return_data = TRUE)
write.taf(bar_dat, file = file_name(cap_year,ecoreg_code,"SAG_Current_elasmobranch", ext = "csv", dir = "report"))
# write.taf(bar_dat, file =file_name(cap_year,ecoreg_code,"SAG_Current_elasmobranch", ext = "csv"), dir = "report" )

kobe <- plot_kobe(catch_current, guild = "elasmobranch", caption = TRUE, cap_year , cap_month , return_data = FALSE)
#check this file name
png(file_name(cap_year,ecoreg_code,"SAG_Current_elasmobranch", ext = "png", dir = "report"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "elasmobranch")
dev.off()

# 5. Crustacean
#~~~~~~~~~~~
# catch_current$Status[which(catch_current$StockKeyLabel == "sol.27.20-24")] <- "GREEN"
# 
# bar <- plot_CLD_bar(catch_current, guild = "crustacean", caption = TRUE, cap_year , cap_month , return_data = FALSE)
# 
# bar_dat <- plot_CLD_bar(catch_current, guild = "crustacean", caption = TRUE, cap_year , cap_month , return_data = TRUE)
# write.taf(bar_dat, file =paste0(year_cap, "_", ecoreg, "_FO_SAG_Current_crustacean.csv"), dir = "report" )
# 
# kobe <- plot_kobe(catch_current, guild = "crustacean", caption = TRUE, cap_year , cap_month , return_data = FALSE)
# #check this file name
# png("report/2020_ONA_FO_SAG_Current_crustacean.png",
#     width = 131.32,
#     height = 88.9,
#     units = "mm",
#     res = 300)
# p1_plot<-gridExtra::grid.arrange(kobe,
#                                  bar, ncol = 2,
#                                  respect = TRUE, top = "benthic")
# dev.off()



# 6. All
#~~~~~~~~~~~
bar <- plot_CLD_bar(catch_current, guild = "All", caption = TRUE, cap_year , cap_month , return_data = FALSE)

bar_dat <- plot_CLD_bar(catch_current, guild = "All", caption = TRUE, cap_year, cap_month , return_data = TRUE)
write.taf(bar_dat, file = file_name(cap_year,ecoreg_code,"SAG_Current_All", ext = "csv", dir = "report"))
# write.taf(bar_dat, file =file_name(cap_year,ecoreg_code,"SAG_Current_All", ext = "csv"), dir = "report" )

top_10 <- bar_dat %>% top_n(10, total)
bar <- plot_CLD_bar(top_10, guild = "All", caption = TRUE, cap_year , cap_month , return_data = FALSE)

kobe <- plot_kobe(top_10, guild = "All", caption = TRUE, cap_year, cap_month , return_data = FALSE)

# kobe <- plot_kobe(catch_current, guild = "All", caption = TRUE, cap_year, cap_month , return_data = FALSE)
#check this file name
png(file_name(cap_year,ecoreg_code,"SAG_Current_All", ext = "png", dir = "report"),
    width = 131.32,
    height = 88.9,
    units = "mm",
    res = 300)
p1_plot<-gridExtra::grid.arrange(kobe,
                                 bar, ncol = 2,
                                 respect = TRUE, top = "All stocks")
dev.off()


#~~~~~~~~~~~~~~~#
# C. Discards
#~~~~~~~~~~~~~~~#
discardsA <- plot_discard_trends(catch_trends, year, cap_year, cap_month )
catch_trends2 <- catch_trends %>% filter(FisheriesGuild != "elasmobranch")
discardsA <- plot_discard_trends(catch_trends2, year, cap_year, cap_month )

dat <- plot_discard_trends(catch_trends, year, cap_year , cap_month , return_data = TRUE)

write.taf(dat, file =file_name(cap_year,ecoreg_code,"SAG_Discards_trends", ext = "csv", dir = "report" ))

df5 <- df %>% filter(discards > 0)
catch_trends3 <- catch_trends2 %>% filter(discards > 0)
discardsB <- plot_discard_current(catch_trends3, year,position_letter = "b)", cap_year , cap_month , caption = FALSE)

discardsC <- plot_discard_current(catch_trends2, year,position_letter = "c)", cap_year , cap_month , caption = TRUE)

#Need to change order?
dat <- plot_discard_current(catch_trends, year, cap_year, cap_month , return_data = TRUE)
write.taf(dat, file =file_name(cap_year,ecoreg_code,"SAG_Discards_current", ext = "csv", dir = "report" ))

cowplot::plot_grid(discardsA, discardsB, discardsC, align = "h",nrow = 1, rel_widths = 1, rel_heights = 1)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_Discards", ext = "png", dir = "report"),  width = 220.32, height = 88.9, units = "mm", dpi = 300)
# ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_Discards", ext = "png"),path = "report/", width = 220.32, height = 88.9, units = "mm", dpi = 300)


#~~~~~~~~~~~~~~~#
#D. ICES pies
#~~~~~~~~~~~~~~~#

plot_status_prop_pies(clean_status, cap_month, cap_year)
unique(clean_status$StockSize)
clean_status$StockSize <- gsub("qual_RED", "RED", clean_status$StockSize)
plot_status_prop_pies(clean_status, cap_month, cap_year)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_ICESpies", ext = "png", dir = "report"),  width = 178, height = 178, units = "mm", dpi = 300)
# ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_ICESpies", ext = "png"), path= "report/", width = 178, height = 178, units = "mm", dpi = 300)

dat <- plot_status_prop_pies(clean_status, cap_month, cap_year, return_data = TRUE)
write.taf(dat, file= file_name(cap_year,ecoreg_code,"SAG_ICESpies", ext = "csv",dir ="report"))

#~~~~~~~~~~~~~~~#
#E. GES pies
#~~~~~~~~~~~~~~~#
# need to check what is that weird zero!!
#Need to change order and fix numbers
plot_GES_pies(clean_status, catch_current, cap_month, cap_year)

unique(clean_status$FishingPressure)
unique(clean_status$StockSize)
clean_status2 <- clean_status
clean_status2$StockSize <- gsub("qual_RED", "RED", clean_status2$StockSize) 
plot_GES_pies(clean_status2, catch_current, cap_month, cap_year)
ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_GESpies", ext = "png", dir = "report"), width = 178, height = 178, units = "mm", dpi = 300)
# ggplot2::ggsave(file_name(cap_year,ecoreg_code,"SAG_GESpies", ext = "png"),path = "report", width = 178, height = 178, units = "mm",dpi = 300)

dat <- plot_GES_pies(clean_status, catch_current, cap_month, cap_year, return_data = TRUE)
write.taf(dat, file = file_name(cap_year,ecoreg_code,"SAG_GESpies", ext = "csv",dir ="report"))

#~~~~~~~~~~~~~~~#
#F. ANNEX TABLE
#~~~~~~~~~~~~~~~#

################################################# NOT WORKING unless I copy and run the devel
#### version of format_annex_table

dat <- format_annex_table(clean_status, year)

write.taf(dat, file = file_name(cap_year,ecoreg_code,"SAG_annex_table", ext = "csv", dir = "report"), quote = TRUE)

format_annex_table_html(dat, cap_year, ecoreg_code)
# This annex table has to be edited by hand,
# For SBL and GES only one values is reported,
# the one in PA for SBL and the one in MSY for GES
