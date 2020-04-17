# Sidenote: Parse RATEE
library(tidyr)
library(dplyr)
library(tibble)
library(xml2)

ratee <- "C:/Users/Ethan/Documents/edge/edgexml/XML XSD/DDC_RATEE_XSD_XML_083019/RATransferElementsExtract.xml"

tbl_ratee <- read_xml(ratee) %>%
  as_list() %>%
  as_tibble() %>%
  unnest_wider(raTransferReport)

tbl_head <- tbl_ratee %>%
  select(outboundFileIdentifier:issuerIdentifier) %>%
  filter(outboundFileIdentifier != "NA") %>%
  unnest(cols = names(.))

tbl_body <- tbl_ratee %>%
  select(planIdentifier:includedRatingAreaCategory) %>%
  filter(planIdentifier != "NA") %>%
  unnest(1:4) %>%
  pivot_longer(cols = starts_with("includedRatingAreaCategory")) %>%
  select(-name) %>%
  filter(value != "NA")

tbl_main <- tbl_body %>%
  unnest_wider(value) %>%
  unnest(cols = names(.)) %>%
  unnest(cols = names(.))

tbl_main %>% View()
