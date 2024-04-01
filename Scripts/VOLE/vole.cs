using Godot;
using System;

public class vole : Control
{
	private Label[,] mem = new Label[17, 17];
	private Label[,] regs = new Label[16, 2];
	private Label[,] spRegs = new Label[2, 2];
	private Button clearb;
	private Button loadb;
	private Button runb;
	private Button stepb;
	private Button haltb;
	private Button helpb;
	private bool running;

	public override void _Ready()
	{
		InitUI();
	}

	private void InitUI()
	{
		// Initialize UI elements
		VBoxContainer mainContainer = new VBoxContainer();
		AddChild(mainContainer);

		// Main Memory Panel
		VBoxContainer memPanel = new VBoxContainer();
		memPanel.AddChild(new Label() { Text = "Main Memory", Align = Label.AlignEnum.Center });
		GridContainer memGrid = new GridContainer() { Columns = 17 };
		memPanel.AddChild(memGrid);
		for (int i = 0; i < 17; i++)
		{
			for (int j = 0; j < 17; j++)
			{
				mem[i, j] = new Label() { Text = "00", Align = Label.AlignEnum.Center };
				memGrid.AddChild(mem[i, j]);
			}
		}
		mainContainer.AddChild(memPanel);

		// CPU Panel
		VBoxContainer cpuPanel = new VBoxContainer();
		cpuPanel.AddChild(new Label() { Text = "CPU", Align = Label.AlignEnum.Center });

		GridContainer regGrid = new GridContainer() { Columns = 2 };
		cpuPanel.AddChild(regGrid);
		for (int i = 0; i < 16; i++)
		{
			regs[i, 0] = new Label() { Text = $"R{i}", Align = Label.AlignEnum.Center };
			regs[i, 1] = new Label() { Text = "00", Align = Label.AlignEnum.Center };
			regGrid.AddChild(regs[i, 0]);
			regGrid.AddChild(regs[i, 1]);
		}

		GridContainer spRegGrid = new GridContainer() { Columns = 2 };
		cpuPanel.AddChild(spRegGrid);
		spRegs[0, 0] = new Label() { Text = "PC", Align = Label.AlignEnum.Center };
		spRegs[0, 1] = new Label() { Text = "00", Align = Label.AlignEnum.Center };
		spRegs[1, 0] = new Label() { Text = "IR", Align = Label.AlignEnum.Center };
		spRegs[1, 1] = new Label() { Text = "0000", Align = Label.AlignEnum.Center };
		spRegGrid.AddChild(spRegs[0, 0]);
		spRegGrid.AddChild(spRegs[0, 1]);
		spRegGrid.AddChild(spRegs[1, 0]);
		spRegGrid.AddChild(spRegs[1, 1]);
		mainContainer.AddChild(cpuPanel);

		// Data Input Window Panel
		VBoxContainer inputPanel = new VBoxContainer();
		inputPanel.AddChild(new Label() { Text = "Data Input Window", Align = Label.AlignEnum.Center });
		TextEdit inArea = new TextEdit();
		inArea.RectMinSize = new Vector2(300, 200);
		inputPanel.AddChild(inArea);
		mainContainer.AddChild(inputPanel);

		// Control Buttons
		HBoxContainer controlButtons = new HBoxContainer();
		mainContainer.AddChild(controlButtons);

		clearb = new Button() { Text = "Clear Memory" };
		clearb.Connect("pressed", this, nameof(OnClearButtonPressed));
		controlButtons.AddChild(clearb);

		loadb = new Button() { Text = "Load Data" };
		loadb.Connect("pressed", this, nameof(OnLoadButtonPressed));
		controlButtons.AddChild(loadb);

		runb = new Button() { Text = "Run" };
		runb.Connect("pressed", this, nameof(OnRunButtonPressed));
		controlButtons.AddChild(runb);

		stepb = new Button() { Text = "Single Step" };
		stepb.Connect("pressed", this, nameof(OnStepButtonPressed));
		controlButtons.AddChild(stepb);

		haltb = new Button() { Text = "Halt" };
		haltb.Connect("pressed", this, nameof(OnHaltButtonPressed));
		controlButtons.AddChild(haltb);

		helpb = new Button() { Text = "Help" };
		helpb.Connect("pressed", this, nameof(OnHelpButtonPressed));
		controlButtons.AddChild(helpb);
	}

	private void OnClearButtonPressed()
	{
		ClearMem();
	}

	private void OnLoadButtonPressed()
	{
		InitMem();
	}

	private void OnRunButtonPressed()
	{
		DoRun();
	}

	private void OnStepButtonPressed()
	{
		DoStep();
	}

	private void OnHaltButtonPressed()
	{
		running = false;
	}

	private void OnHelpButtonPressed()
	{
		GetHelp();
	}

	private void ClearMem()
	{
		for (int i = 0; i < 17; i++)
		{
			for (int j = 0; j < 17; j++)
			{
				mem[i, j].Text = "00";
			}
		}
	}

	private void GetHelp()
	{
		// Display help dialog
		// Your code to display help here
	}

	private void InitMem()
	{
		// Initialize memory content
		// Your code to initialize memory here
	}

	private void DoStep()
	{
		// Execute one step of the machine
		// Your code for executing one step here
	}

	private void DoRun()
	{
		// Run the program
		// Your code to run the program here
	}
}
