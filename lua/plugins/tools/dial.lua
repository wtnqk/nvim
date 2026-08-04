return {
  {
    "monaqa/dial.nvim",
    keys = {
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, desc = "Increment (sequential)" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, desc = "Decrement (sequential)" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, desc = "Increment (sequential)", mode = "v" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, desc = "Decrement (sequential)", mode = "v" },
    },
  },
}
