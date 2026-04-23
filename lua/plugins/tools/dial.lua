return {
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end,  desc = "Increment" },
      { "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end,  desc = "Decrement" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, desc = "Increment (sequential)" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, desc = "Decrement (sequential)" },
      { "<C-a>",  function() require("dial.map").manipulate("increment", "visual") end,  desc = "Increment",              mode = "v" },
      { "<C-x>",  function() require("dial.map").manipulate("decrement", "visual") end,  desc = "Decrement",              mode = "v" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, desc = "Increment (sequential)", mode = "v" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, desc = "Decrement (sequential)", mode = "v" },
    },
  },
}
