module inventoryview;

import dvn;

bool[string] inventory;

public final class InventoryView : View
{
    public:
    final:
    this(Window window)
    {
        super(window);
    }

    protected override void onInitialize(bool useCache)
    {
        EXT_DisableKeyboardState();

        auto window = super.window;
        auto settings = getGlobalSettings();

        auto label = new Label(window);
        addComponent(label);
        label.fontName = settings.defaultFont;
        label.fontSize = 24;
        label.color = "fff".getColorByHex;
        label.text = "What item do you want to use?";
        label.shadow = true;
        label.anchor = Anchor.top;
        label.updateRect();
        label.show();

        Label lastLabel = label;

        foreach (item,v; inventory)
        {
            import std.conv : to;

            auto itemLabel = new Label(window);
            addComponent(itemLabel);
            itemLabel.fontName = settings.defaultFont;
            itemLabel.fontSize = 24;
			itemLabel.color = "fff".getColorByHex;
            itemLabel.text = item.to!dstring;
            itemLabel.shadow = true;
            itemLabel.moveBelow(lastLabel, 16, true);
            itemLabel.updateRect();
            itemLabel.show();

            lastLabel = itemLabel;

            // We need to make a closure else the foreach loop swallows our label and item

            auto closure = (Label l, string itemName) { return () {
                l.onMouseButtonUp(new MouseButtonEventHandler((b,p) {
                    switch (itemName)
                    {
                        case "rusty-key":
                            displayScene("Inventory System-door-open");
                            break;

                        default: break;
                    }
                }));
            };};

            closure(itemLabel, item)();
        }
    }
}