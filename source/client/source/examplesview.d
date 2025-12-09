module examplesview;

import dvn;

import std.conv : to;

public final class ExamplesView : View
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

        auto bgImage = new Image(window, "MainMenuBackground");
        addComponent(bgImage);
        bgImage.position = IntVector(
            (window.width / 2) - (bgImage.width / 2),
            (window.height / 2) - (bgImage.height / 2));
        bgImage.show();

        Label lastComponent;

        auto panel = new Panel(window);
		addComponent(panel);
		panel.size = IntVector(window.width - 16, window.height);
		panel.position = IntVector(0, 0);
		panel.show();
        
        auto scrollBar = new ScrollBar(window, panel);
        addComponent(scrollBar);
        scrollBar.isVertical = true;
        scrollBar.fillColor = getColorByRGB(0,0,0,150);
        scrollBar.borderColor = getColorByRGB(0,0,0,150);
        panel.scrollMargin = IntVector(0,cast(int)((cast(double)panel.height / 3.5) / 2));
        scrollBar.position = IntVector(panel.x + panel.width, panel.y);
        scrollBar.buttonScrollAmount = cast(int)((cast(double)panel.height / 3.5) / 2);
        scrollBar.fontName = settings.defaultFont;
        scrollBar.fontSize = 8;
        scrollBar.buttonTextColor = "fff".getColorByHex;
        scrollBar.createDecrementButton("▲", "◀");
        scrollBar.createIncrementButton("▼", "▶");
        scrollBar.size = IntVector(16, panel.height+1);
        scrollBar.restyle();
        scrollBar.updateRect(false);

        void buildHeader(string text)
        {
            auto label = new Label(window);
            panel.addComponent(label);

            label.fontName = settings.defaultFont;
            label.fontSize = 28;
            label.color = "fff".getColorByHex;
            label.shadow = true;
            label.text = text.to!dstring;
            if (lastComponent)
            {
                label.moveBelow(lastComponent, 32, true);
            }
            else
            {
                label.anchor = Anchor.top;
                label.position = IntVector(label.x, 16);
            }

            label.updateRect();
            label.show();

            lastComponent = label;
        }

        void buildExample(string text)
        {
            auto label = new Label(window);
            panel.addComponent(label);

            label.fontName = settings.defaultFont;
            label.fontSize = 18;
            label.color = "fff".getColorByHex;
            label.shadow = true;
            label.isLink = true;
            label.text = text.to!dstring;
            if (lastComponent)
            {
                label.moveBelow(lastComponent, 16, true);
            }
            else
            {
                label.anchor = Anchor.top;
                label.position = IntVector(label.x, 16);
            }

            label.updateRect();
            label.show();

            lastComponent = label;
            
            label.onMouseButtonUp(new MouseButtonEventHandler((b,p)
            {
                displayScene(text);
            }));
        }

        buildHeader("Beginner");

        buildExample("Hello World");
        buildExample("Basic Character Dialogue");
        buildExample("Choices (Simple Branching)");
        buildExample("Play a Sound Effect");
        buildExample("Scene Navigation #1");
        buildExample("Scene Navigation #2");

        buildHeader("Intermediate");
        buildExample("Branching Narrative With Variables");
        buildExample("Conditional Dialogue");
        buildExample("Custom Character Expressions");
        buildExample("Effects Chain Example");
        buildExample("Simple Animation/Movement");
        buildExample("Timed Narrative Events #1");
        buildExample("Timed Narrative Events #2");
        buildExample("Basic UI Modification");
        buildExample("Importing JSON or CSV");
        buildExample("Randomized Narrative Events");

        buildHeader("Advanced (Power Users)");
        buildExample("Minigame / Interaction (Custom Gameplay)");
        buildExample("Inventory System");

        scrollBar.restyle();
        scrollBar.updateRect(false);
        panel.makeScrollableWithWheel();
    }
}