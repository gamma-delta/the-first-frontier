require "prototypes/random-things"
require "prototypes/entities/squibs"

require "prototypes/planets"

require "prototypes/items"
require "prototypes/fluids"
require "prototypes/entities/machines"
require "prototypes/entities/resources"
require "prototypes/entities/combat"
require "prototypes/entities/nauvis"
require "prototypes/entities/vulcanus"
require "prototypes/entities/fulgora"
require "prototypes/entities/gleba"
require "prototypes/entities/enemies/sapper"
require "prototypes/entities/platforms"

require "prototypes/recipes/tier-0"
require "prototypes/recipes/rocket"
require "prototypes/recipes/space"
require "prototypes/recipes/nauvis-nuclear-1"
require "prototypes/recipes/vulcanus-1"
require "prototypes/recipes/gleba-1"
require "prototypes/recipes/fulgora-1"
require "prototypes/recipes/post-inner-t1"
require "prototypes/recipes/vulcanus-2"
require "prototypes/recipes/science"

require "prototypes/tiles"

require "prototypes/technologies/main"
require "prototypes/technologies/no-infinites"
require "prototypes/entities/misc"

require "prototypes/dust-pollution"

require "prototypes/tips-and-tricks"

-- Updating recipes must be done in data stage so that quality catches them.
require "prototypes/recipe-updates/science"
require "prototypes/recipe-updates/tier-0"
require "prototypes/recipe-updates/space"
require "prototypes/recipe-updates/nauvis-nuclear"
require "prototypes/recipe-updates/vulcanus"
require "prototypes/recipe-updates/fulgora"
require "prototypes/recipe-updates/gleba"
require "prototypes/recipe-updates/misc"

-- jansharp, you are the BEST
local qai = require "__quick-adjustable-inserters__/data_api"
qai.exclude("")
qai.include(qai.to_plain_pattern("tentacle-inserter"))
