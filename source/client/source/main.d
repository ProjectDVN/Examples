module main;

import dvn;

import core.stdc.stdlib : exit;

version (Windows)
{
	import core.runtime;
	import core.sys.windows.windows;
	import std.string;
	
	pragma(lib, "user32");

	extern (Windows)
	int WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
				LPSTR lpCmdLine, int nCmdShow)
	{
		int result;

		try
		{
			Runtime.initialize();
			result = myWinMain(hInstance, hPrevInstance, lpCmdLine, nCmdShow);
			Runtime.terminate();
		}
		catch (Throwable e) 
		{
			import std.file : write;

			write("errordump.log", e.toString);

			MessageBoxA(null, e.toString().toStringz(), null,
						MB_ICONEXCLAMATION);
			exit(0);
			result = 0;     // failed
		}

		return result;
	}

	int myWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
				LPSTR lpCmdLine, int nCmdShow)
	{
		mainEx();
		return 0;
	}
}
else
{
	void main()
	{
		try
		{
			mainEx();
		}
		catch (Throwable e)
		{
			import std.stdio : writeln, readln;
			import std.file : write;

			write("errordump.log", e.toString);
			
			writeln(e);

			exit(0);
		}
	}
}

string drink;
bool hasKey;
bool isUIModificationScene;
string[] fruits;

import inventoryview;

public final class Events : DvnEvents
{
	override void engineReady(Application app, Window[] windows)
	{
		import std.file : readText;
		auto text = readText("fruits.json");

		string[] errorMessages;
		if (!deserializeJsonSafe!(string[])(text, fruits, errorMessages))
		{
			throw new Exception(errorMessages[0]);
		}
	}

	public override void loadingViews(Window window)
	{
		import examplesview;
		window.addView!ExamplesView("ExamplesView");
		import rockscissorpaperview;
    	window.addView!RockScissorPaperView("RockScissorPaperView");
		window.addView!InventoryView("InventoryView");
	}

	override void loadedGameScripts(SceneEntry[string] scenes, SaveFile saveFile)
	{
		drink = "";
    	hasKey = false;
	}

	override void beginHandleScene(ref SceneEntry scene, ref SceneEntry nextScene, bool isEnding, SceneEntry[string] scenes)
	{
		isUIModificationScene = scene.original == "Basic UI Modification";

		if (scene.name == "Branching Narrative With Variables-coffee")
			drink = "coffee";
		else if (scene.name == "Branching Narrative With Variables-tea")
			drink = "tea";
		else if (scene.original == "Branching Narrative With Variables-final")
		{
			scene.text = scene.text.replace("{drink}", drink);
		}

		if (scene.name == "Conditional Dialogue-pick-up-key")
        	hasKey = true;
		else if (scene.original == "Conditional Dialogue-final")
		{
			if (scene.text == "{result}")
			{
				if (hasKey) scene.text = "You open the door.";
				else scene.text = "You can't open the door.";
			}
		}

		if (scene.original == "Importing JSON or CSV")
		{
			import std.array : join;

			scene.text = scene.text.replace("{fruits}", fruits.join(", "));
		}

		if (scene.original == "Inventory System-pickup")
		{
			inventory["rusty-key"] = true;
		}
		else if (scene.original == "Inventory System-room")
		{
			if (!("rusty-key" in inventory))
			{
				nextScene = null;
			}
		}
	}

	override void renderGameViewDialoguePanel(Panel panel)
	{
		if (!isUIModificationScene) return;

		panel.position = IntVector(
			panel.x, // Keep the current X position
			16       // Move the panel to the top with a 16px margin
		);
	}
}

void mainEx()
{
	DvnEvents.setEvents(new Events);

	runDVN();
}
