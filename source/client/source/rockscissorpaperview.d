module rockscissorpaperview;

import dvn;

public final class RockScissorPaperView : View
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
        label.text = "What do you pick?";
        label.shadow = true;
        label.anchor = Anchor.top;
        label.updateRect();
        label.show();

        void pick(string value)
        {
			import std.random : uniform;

            string alicePicked;
            auto result = uniform(0, 100);
            if (result > 66) alicePicked = "rock";
            else if (result > 33) alicePicked = "scissor";
            else alicePicked = "paper";

            string scene;

            if (value == "rock")
            {
                if (alicePicked == "scissor") scene = "win";
                else if (alicePicked == "paper") scene = "lose";
                else scene = "draw";
            }
            else if (value == "scissor")
            {
                if (alicePicked == "paper") scene = "win";
                else if (alicePicked == "rock") scene = "lose";
                else scene = "draw";
            }
            else // if (value == "paper")
            {
                if (alicePicked == "rock") scene = "win";
                else if (alicePicked == "scissor") scene = "lose";
                else scene = "draw";
            }

            displayScene("Minigame / Interaction (Custom Gameplay)-" ~ scene);
        }

        auto rock = new Button(window);
        addComponent(rock);
        rock.fontName = settings.defaultFont;
        rock.fontSize = 32;
        rock.text = "Rock";
        rock.size = IntVector(window.width / 2, 64);
        rock.moveBelow(label, 16, true);
        rock.show();
        rock.onButtonClick(new MouseButtonEventHandler((b,p)
        {
            pick("rock");
        }));

        auto scissor = new Button(window);
        addComponent(scissor);
        scissor.fontName = settings.defaultFont;
        scissor.fontSize = 32;
        scissor.text = "Scissor";
        scissor.size = IntVector(window.width / 2, 64);
        scissor.moveBelow(rock, 16, true);
        scissor.show();
        scissor.onButtonClick(new MouseButtonEventHandler((b,p)
        {
            pick("scissor");
        }));

        auto paper = new Button(window);
        addComponent(paper);
        paper.fontName = settings.defaultFont;
        paper.fontSize = 32;
        paper.text = "Paper";
        paper.size = IntVector(window.width / 2, 64);
        paper.moveBelow(scissor, 16, true);
        paper.show();
        paper.onButtonClick(new MouseButtonEventHandler((b,p)
        {
            pick("paper");
        }));
    }
}