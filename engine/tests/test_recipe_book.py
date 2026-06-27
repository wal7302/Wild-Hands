from engine.family.recipe_book import FamilyRecipeBook, Recipe, RecipeCategory


book = FamilyRecipeBook(
    family_club_id="family_001"
)

recipe = Recipe(
    recipe_id="grace_red_sangria",
    title="Grace's Red Sangria",
    category=RecipeCategory.DRINK,
    submitted_by="Grace Lott",
    ingredients=[
        "Red wine",
        "Orange slices",
        "Berries",
        "A splash of something special",
    ],
    instructions=[
        "Mix everything in a pitcher.",
        "Chill before game night.",
        "Serve with laughter.",
    ],
    story="Grace says this pairs well with a bad hand and good company.",
)

added = book.add_recipe(recipe)

assert added is True
assert book.find_recipe("grace_red_sangria").title == "Grace's Red Sangria"
assert len(book.recipes_by_category(RecipeCategory.DRINK)) == 1

print("Recipe book test passed.")
