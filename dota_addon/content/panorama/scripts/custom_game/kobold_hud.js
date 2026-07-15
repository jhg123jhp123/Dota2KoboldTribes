(function () {
    "use strict";

    function localHero() {
        var playerId = Players.GetLocalPlayer();
        return Players.GetPlayerHeroEntityIndex(playerId);
    }

    function setMeter(prefix, value, maxValue) {
        value = Number(value || 0);
        maxValue = Number(maxValue || 100);

        var bar = $("#" + prefix + "Bar");
        var label = $("#" + prefix + "Value");
        if (!bar || !label) {
            return;
        }

        bar.max = maxValue;
        bar.value = Math.max(0, Math.min(maxValue, value));
        label.text = Math.round(value).toString();
    }

    function formatResources(resources) {
        if (!resources) {
            return "No tribe resource table yet.";
        }

        var keys = Object.keys(resources).sort();
        var visible = [];
        for (var i = 0; i < keys.length; i++) {
            var key = keys[i];
            var amount = Number(resources[key] || 0);
            if (amount > 0) {
                visible.push(key.replace("resource_", "").replace("ingredient_", "") + ": " + amount);
            }
        }

        return visible.length > 0 ? visible.join("  |  ") : "Stores are empty.";
    }

    function updateHud() {
        var hero = localHero();
        if (hero && hero !== -1) {
            var survival = CustomNetTables.GetTableValue("kobold_survival", String(hero));
            if (survival) {
                setMeter("Hunger", survival.hunger, survival.maxHunger);
                setMeter("Warmth", survival.warmth, survival.maxWarmth);
                setMeter("Stamina", survival.stamina, survival.maxStamina);
            }

            var team = Entities.GetTeamNumber(hero);
            var resources = CustomNetTables.GetTableValue("kobold_resources", String(team));
            var resourceText = $("#ResourceText");
            if (resourceText) {
                resourceText.text = formatResources(resources);
            }
        }
    }

    function updateLoop() {
        updateHud();
        $.Schedule(0.25, updateLoop);
    }

    CustomNetTables.SubscribeNetTableListener("kobold_survival", updateHud);
    CustomNetTables.SubscribeNetTableListener("kobold_resources", updateHud);
    updateLoop();
})();
