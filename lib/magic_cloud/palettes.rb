# frozen_string_literal: true

module MagicCloud
  PALETTES = {
    # Categorical colors from d3
    # Source: https://github.com/d3/d3-scale/blob/master/README.md#category-scales

    category10: %w[
      #1f77b4 #ff7f0e #2ca02c #d62728 #9467bd
      #8c564b #e377c2 #7f7f7f #bcbd22 #17becf
    ],

    category20: %w[
      #1f77b4 #aec7e8 #ff7f0e #ffbb78 #2ca02c
      #98df8a #d62728 #ff9896 #9467bd #c5b0d5
      #8c564b #c49c94 #e377c2 #f7b6d2 #7f7f7f
      #c7c7c7 #bcbd22 #dbdb8d #17becf #9edae5
    ],

    category20b: %w[
      #393b79 #5254a3 #6b6ecf #9c9ede #637939
      #8ca252 #b5cf6b #cedb9c #8c6d31 #bd9e39
      #e7ba52 #e7cb94 #843c39 #ad494a #d6616b
      #e7969c #7b4173 #a55194 #ce6dbd #de9ed6
    ],

    category20c: %w[
      #3182bd #6baed6 #9ecae1 #c6dbef #e6550d
      #fd8d3c #fdae6b #fdd0a2 #31a354 #74c476
      #a1d99b #c7e9c0 #756bb1 #9e9ac8 #bcbddc
      #dadaeb #636363 #969696 #bdbdbd #d9d9d9
    ]
  }.freeze
end
