local RecipeService = {}
RecipeService.__index = RecipeService

local RECIPES = {
    recipe_roasted_lamb = {
        itemName = "item_food_roasted_lamb",
        costs = {
            { id = "ingredient_raw_lamb", count = 1 },
        },
        xp = 10,
    },
    recipe_wolf_steak = {
        itemName = "item_food_wolf_steak",
        costs = {
            { id = "ingredient_raw_wolf_meat", count = 1 },
        },
        xp = 12,
    },
    recipe_pheasant_berry_sauce = {
        itemName = "item_food_pheasant_berry_sauce",
        costs = {
            { id = "ingredient_raw_pheasant", count = 1 },
            { id = "ingredient_handful_berries", count = 1 },
        },
        xp = 16,
    },
    recipe_spiced_lamb_feast = {
        itemName = "item_food_spiced_lamb_feast",
        costs = {
            { id = "ingredient_raw_lamb", count = 1 },
            { id = "ingredient_spicy_herbs", count = 1 },
        },
        xp = 22,
    },
    recipe_grilled_wolf_entrecote = {
        itemName = "item_food_grilled_wolf_entrecote",
        costs = {
            { id = "ingredient_raw_wolf_meat", count = 1 },
            { id = "ingredient_spicy_herbs", count = 1 },
        },
        xp = 24,
    },
    recipe_beer_braised_pheasant = {
        itemName = "item_food_beer_braised_pheasant",
        costs = {
            { id = "ingredient_raw_pheasant", count = 1 },
            { id = "ingredient_beer", count = 1 },
        },
        xp = 30,
    },
    recipe_burgundian_smoked_bear_cutlet = {
        itemName = "item_food_burgundian_bear_cutlet",
        costs = {
            { id = "ingredient_raw_bear_meat", count = 1 },
            { id = "ingredient_beer", count = 1 },
        },
        xp = 36,
    },
    recipe_smoked_lamb_sirloin = {
        itemName = "item_food_smoked_lamb_sirloin",
        costs = {
            { id = "ingredient_raw_lamb", count = 2 },
            { id = "ingredient_spicy_herbs", count = 1 },
            { id = "ingredient_lambent_sunflower", count = 1 },
        },
        xp = 42,
    },
    recipe_glimmer_cheese = {
        itemName = "item_food_glimmer_cheese",
        costs = {
            { id = "ingredient_handful_berries", count = 1 },
            { id = "ingredient_sageberry", count = 1 },
            { id = "ingredient_beer", count = 1 },
        },
        xp = 42,
    },
    recipe_stag_stew = {
        itemName = "item_food_stag_stew",
        costs = {
            { id = "ingredient_raw_stag_meat", count = 1 },
            { id = "ingredient_lambent_sunflower", count = 1 },
        },
        xp = 50,
    },
    recipe_powdered_flask = {
        itemName = "item_active_powdered_flask",
        chargesProduced = 3,
        costs = {
            { id = "resource_shadowstone", count = 1 },
            { id = "ingredient_spicy_herbs", count = 1 },
        },
        xp = 28,
    },
    recipe_cleansing_draught = {
        itemName = "item_active_cleansing_draught",
        chargesProduced = 3,
        costs = {
            { id = "ingredient_sageberry", count = 1 },
            { id = "ingredient_spicy_herbs", count = 1 },
        },
        xp = 28,
    },
    recipe_diseased_cocktail = {
        itemName = "item_active_diseased_cocktail",
        chargesProduced = 2,
        costs = {
            { id = "ingredient_draught_of_decay", count = 1 },
            { id = "ingredient_spicy_herbs", count = 1 },
        },
        xp = 36,
    },
    recipe_unstable_concoction = {
        itemName = "item_active_unstable_concoction",
        chargesProduced = 2,
        costs = {
            { id = "resource_shadowstone", count = 1 },
            { id = "ingredient_sageberry", count = 1 },
        },
        xp = 44,
    },
    recipe_drunken_booze = {
        itemName = "item_active_drunken_booze",
        chargesProduced = 2,
        costs = {
            { id = "ingredient_beer", count = 1 },
            { id = "ingredient_spicy_herbs", count = 1 },
        },
        xp = 38,
    },
    recipe_elixir_of_mastery = {
        itemName = "item_active_elixir_mastery",
        costs = {
            { id = "resource_radiant_gemstone", count = 1 },
            { id = "ingredient_sageberry", count = 1 },
            { id = "ingredient_lambent_sunflower", count = 1 },
        },
        xp = 90,
    },
    recipe_fishing_rod = {
        itemName = "item_tool_fishing_rod",
        costs = {
            { id = "resource_lumber", count = 2 },
            { id = "ingredient_wool", count = 1 },
        },
        xp = 18,
    },
}

function RecipeService.New(options)
    options = options or {}

    return setmetatable({
        context = options.context,
    }, RecipeService)
end

function RecipeService:CompleteRecipe(caster, recipeId)
    local recipe = RECIPES[recipeId] or RECIPES.recipe_roasted_lamb
    if caster == nil or caster:IsNull() then
        return false
    end

    local resources = self.context and self.context:GetService("resources") or nil
    if resources ~= nil then
        local ok, missing = resources:SpendForTeam(caster:GetTeamNumber(), recipe.costs)
        if not ok then
            print("[Kobold Survival][RecipeService] missing " .. tostring(missing) .. " for " .. recipeId)
            return false
        end
    end

    local produced = math.max(1, recipe.chargesProduced or 1)
    for _ = 1, produced do
        self:CreateItemForCaster(caster, recipe.itemName)
    end

    local progression = self.context and self.context:GetService("progression") or nil
    if progression ~= nil then
        progression:AwardXp(caster, recipe.xp or 0, recipeId)
    end

    return true
end

function RecipeService:CreateItemForCaster(caster, itemName)
    if CreateItem == nil or caster == nil or caster:IsNull() then
        return nil
    end

    local item = CreateItem(itemName, caster, caster)
    if item ~= nil then
        caster:AddItem(item)
    end

    return item
end

return RecipeService
