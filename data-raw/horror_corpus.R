# https://github.com/ropensci/gutenbergr/issues/28
# https://www.datasciencemadesimple.com/remove-duplicate-rows-r-using-dplyr-distinct-function/

alt_mirror <- "http://www.mirrorservice.org/sites/ftp.ibiblio.org/pub/docs/books/gutenberg/"

horror_bookshelf_metadata <- gutenberg_metadata %>%
  filter(str_detect(gutenberg_bookshelf, "Horror")) %>%
  filter(language == "en") %>%
  distinct(title, author, .keep_all = TRUE)

horror_book_ids <- head(horror_bookshelf_metadata$gutenberg_id)

horror_books <- gutenberg_download(horror_book_ids, mirror = alt_mirror) %>%
  group_by(gutenberg_id) %>% summarise(text = paste(text, collapse = " "))

horror_books_w_metadata <- left_join(horror_books, horror_bookshelf_metadata) %>%
  select(title, text, author)

saveRDS(horror_books_w_metadata, file = "data/horror.rds")
