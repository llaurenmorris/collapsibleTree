attach("www/Elasmobranchii.Rda")

# Existing chart
collapsibleTree(Elasmobranchii, c("ORDER", "FAMILY", "GENUS"), width=600, collapsed = TRUE, zoomable = FALSE)

library(dplyr)
library(tidyr)
library(data.tree)

root <- "Elasmobranchii"
hierarchy <- c("ORDER", "FAMILY", "GENUS")

# collapsibleTree behind the scenes
# Converting rectangular data.frame into data.tree
Elasmobranchii_tree <- Elasmobranchii %>%
  mutate(pathString = paste(root, apply(.[, hierarchy], 1, paste, collapse = "//"), sep = "//")) %>%
  data.tree::as.Node(pathDelimiter = "//")

print(Elasmobranchii_tree)

# Convert it back into a data.frame, more normal to work with
Elasmobranchii_network <- ToDataFrameNetwork(Elasmobranchii_tree) %>%
  # Include the root name
  bind_rows(tibble(from = NA, to = root))

# Original chart, but with different data
collapsibleTreeNetwork(Elasmobranchii_network)

# Add in a tooltip for each node
Elasmobranchii_tooltips <- Elasmobranchii_network %>%
  mutate(tooltip = paste0(
    "<b>", to, "</b>",
    "<br><img src='https://source.unsplash.com/collection/385548/150x100'>"
  ))

# Tooltip-ed nodes!
collapsibleTreeNetwork(Elasmobranchii_tooltips, tooltipHtml = "tooltip")
