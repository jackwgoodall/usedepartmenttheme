test_that(".normalise_hex accepts 6-digit and 3-digit forms", {
  expect_equal(.normalise_hex("#0d5257"), "#0D5257")
  expect_equal(.normalise_hex("  #0D5257 "), "#0D5257")
  expect_equal(.normalise_hex("#abc"), "#AABBCC")
})

test_that(".normalise_hex rejects invalid input", {
  expect_error(.normalise_hex("0D5257"))
  expect_error(.normalise_hex("#12345"))
  expect_error(.normalise_hex("#GGGGGG"))
  expect_error(.normalise_hex("teal"))
})

test_that("hex/rgb round trip is lossless", {
  hex <- "#0D5257"
  expect_equal(.rgb_to_hex(.hex_to_rgb(hex)), hex)
})

test_that(".lighten mixes toward white", {
  expect_equal(.lighten("#000000", 1), "#FFFFFF")
  expect_equal(.lighten("#336699", 0), "#336699")
  expect_equal(.lighten("#000000", 0.5), "#808080")
})

test_that(".is_dark classifies obvious colours", {
  expect_true(.is_dark("#000000"))
  expect_true(.is_dark("#0D5257"))
  expect_false(.is_dark("#FFFFFF"))
  expect_false(.is_dark("#FFD700"))
})

test_that(".sanitise_name produces valid extension ids", {
  expect_equal(.sanitise_name("My Lab"), "my-lab")
  expect_equal(.sanitise_name("  Stats & Data!  "), "stats-data")
  expect_equal(.sanitise_name("custom"), "custom")
  expect_error(.sanitise_name("!!!"))
  expect_error(.sanitise_name(c("a", "b")))
  expect_error(.sanitise_name(NA_character_))
})
