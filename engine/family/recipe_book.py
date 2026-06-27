from dataclasses import dataclass, field
from datetime import datetime


class RecipeCategory:

    FOOD = "food"
    DRINK = "drink"
    SNACK = "snack"
    DESSERT = "dessert"
    OTHER = "other"


@dataclass
class Recipe:

    recipe_id: str
    title: str
    category: str
    submitted_by: str
    ingredients: list[str] = field(default_factory=list)
    instructions: list[str] = field(default_factory=list)
    story: str = ""
    created_at: datetime = field(default_factory=datetime.now)


class FamilyRecipeBook:

    def __init__(self, family_club_id):

        self.family_club_id = family_club_id
        self.recipes = []

    def add_recipe(self, recipe):

        if self.find_recipe(recipe.recipe_id):
            return False

        self.recipes.append(recipe)

        return True

    def find_recipe(self, recipe_id):

        for recipe in self.recipes:
            if recipe.recipe_id == recipe_id:
                return recipe

        return None

    def recipes_by_category(self, category):

        return [
            recipe
            for recipe in self.recipes
            if recipe.category == category
        ]
