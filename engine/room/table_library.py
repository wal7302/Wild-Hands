class Table:

    def __init__(
        self,
        table_id,
        name,
        material,
        description,
        unlock_level=1,
    ):
        self.table_id = table_id
        self.name = name
        self.material = material
        self.description = description
        self.unlock_level = unlock_level


class TableLibrary:

    SOLID_WOOD_FAMILY_TABLE = Table(
        table_id="solid_wood_family_table",
        name="Solid Wood Family Table",
        material="warm walnut wood",
        description="A well-loved family table built for cards, snacks, and stories.",
        unlock_level=1,
    )

    @staticmethod
    def default_table():
        return TableLibrary.SOLID_WOOD_FAMILY_TABLE

    @staticmethod
    def all_tables():
        return [
            TableLibrary.SOLID_WOOD_FAMILY_TABLE
        ]

    @staticmethod
    def find(table_id):
        for table in TableLibrary.all_tables():
            if table.table_id == table_id:
                return table

        return None
