using Godot;
using System;

public class Simulator2 : Control
{
	TextEdit inArea;
	Label[,] mem = new Label[17, 17];
	Label[,] regs = new Label[16, 2];
	Label[,] spRegs = new Label[2, 2];
	Button clearb, loadb, runb, stepb, haltb, helpb;
	bool running;

	public override void _Ready()
	{
		inArea = GetNode<TextEdit>("InArea");


		// Get references to the buttons
		clearb = GetNode<Button>("ClearButton");
		loadb = GetNode<Button>("LoadButton");
		runb = GetNode<Button>("RunButton");
		stepb = GetNode<Button>("StepButton");
		haltb = GetNode<Button>("HaltButton");
		helpb = GetNode<Button>("HelpButton");
		
		// Connect signals to button clicks
		clearb.Connect("pressed", this, nameof(OnClearButtonPressed));
		loadb.Connect("pressed", this, nameof(OnLoadButtonPressed));
		runb.Connect("pressed", this, nameof(OnRunButtonPressed));
		stepb.Connect("pressed", this, nameof(OnStepButtonPressed));
		haltb.Connect("pressed", this, nameof(OnHaltButtonPressed));
		helpb.Connect("pressed", this, nameof(OnHelpButtonPressed));
		
		
		// Create memory labels and add them to the MemoryGridContainer
		GridContainer memoryGridContainer = GetNode<GridContainer>("MemoryGridContainer");
		for (int i = 0; i < 17; i++)
		{
			for (int j = 0; j < 17; j++)
			{
				Label label = new Label();
				label.Text = "00"; // Default text for memory label
				mem[i, j] = label;
				memoryGridContainer.AddChild(label);
				GD.Print("Label added at position: ", i, ",", j);
			}
		}
	
		// Get references to labels in the CPU panel
		GridContainer cpuPanel = GetNode<GridContainer>("CPUPanel");

		 // Add regular registers (R1-R9) to the CPU panel
	for (int i = 1; i <= 9; i++)
	{
		Label regLabel = new Label();
		regLabel.Text = "R" + i.ToString() + ": 00"; // Decimal representation
		regs[i - 1, 0] = regLabel;
		cpuPanel.AddChild(regLabel);

		Label regValueLabel = new Label();
		regValueLabel.Text = "00"; // Default value for register
		regs[i - 1, 1] = regValueLabel;
		cpuPanel.AddChild(regValueLabel);
	}
	
	// Add registers (RA-RF) to the CPU panel
	for (int i = 10; i <= 15; i++)
	{
		Label regLabel = new Label();
		regLabel.Text = "R" + ((char)('A' + i - 10)) + ": 00"; // Hexadecimal representation
		regs[i, 0] = regLabel;
		cpuPanel.AddChild(regLabel);

		Label regValueLabel = new Label();
		regValueLabel.Text = "00"; // Default value for register
		regs[i, 1] = regValueLabel;
		cpuPanel.AddChild(regValueLabel);
	}
	
	// Add special purpose registers
	string[] spRegNames = { "PC", "IR" };
	for (int i = 0; i < 2; i++)
	{
		Label spRegLabel = new Label();
		spRegLabel.Text = spRegNames[i] + ": 00"; // Default text for special purpose register label
		spRegs[i, 0] = spRegLabel;
		cpuPanel.AddChild(spRegLabel);

		Label spRegValueLabel = new Label();
		spRegValueLabel.Text = "00"; // Default value for special purpose register
		spRegs[i, 1] = spRegValueLabel;
		cpuPanel.AddChild(spRegValueLabel);
	}

	

	
	
	}

	// Define event handlers for button clicks
	// Event handlers for UI actions
	private void OnClearButtonPressed() => ClearMemory();
	private void OnLoadButtonPressed() => LoadData();
	private void OnRunButtonPressed() => RunProgram();
	private void OnStepButtonPressed() => ExecuteSingleStep();
	private void OnHaltButtonPressed() => running = false;
	private void OnHelpButtonPressed() => ShowHelp();

	// Define other methods...

	private void ClearMemory()
{
	// Clear memory UI elements
	for (int i = 0; i < 17; i++)
	{
		for (int j = 0; j < 17; j++)
		{
			mem[i, j].Text = "00"; // Set memory label text to "00"
		}
	}
}

	private void LoadData()
{
	// Parse data from inArea and load into memory UI elements
	InitMemory();
	// Implement parsing and loading logic here
}

	private void RunProgram()
	{
		running = true;
		while (running)
		{
			ExecuteSingleStep();
			// Add delay or other logic as needed
		}
	}


	private void InitMemory()
{
	// Clear various regs, etc.
	for (int i = 0; i < 16; i++)
	{
		regs[i, 1].Text = "00";
	}
	spRegs[0, 1].Text = "00";
	spRegs[1, 1].Text = "0000";

	for (int i = 1; i < 17; i++)
	{
		for (int j = 1; j < 17; j++)
		{
			mem[i, j].Text = "00";
		}
	}

	string input = inArea.Text;

	int address = 0;
	int rNum = 0;
	int ptr = 0;
	bool chgReg = false;
	bool chgMem = false;
	bool chgPC = false;

	while (ptr < input.Length)
	{
		char c = input[ptr];
		if (char.IsWhiteSpace(c))
		{
			ptr++;
			continue;
		}
		else if (c == '[')
		{
			ptr++;
			c = input[ptr];
			if (char.ToUpper(c) == 'R')
			{
				rNum = Convert.ToInt32(input.Substring(ptr + 1, 1));
				chgReg = true;
				chgMem = false;
				chgPC = false;
			}
			else if (char.ToUpper(c) == 'P')
			{
				chgPC = true;
				chgMem = false;
				chgReg = false;
			}
			else
			{
				address = Convert.ToInt32(input.Substring(ptr, 2), 16);
				chgMem = true;
				chgPC = false;
				chgReg = false;
			}
			ptr += 3;
		}
		else // should be hex digit
		{
			int val = Convert.ToInt32(input.Substring(ptr, 2), 16);
			ptr += 2;
			if (chgPC)
			{
				spRegs[0, 1].Text = val.ToString("X2");
			}
			if (chgReg)
			{
				regs[rNum, 1].Text = val.ToString("X2");
			}
			if (chgMem)
			{
				mem[(address / 16) + 1, (address % 16) + 1].Text = val.ToString("X2");
				address++;
			}
		}
	}
}

private void UpdateRegister(int reg, int value)
{
	// Updates the given register with the value, ensuring it is formatted as a 2-digit hexadecimal
	regs[reg, 1].Text = value.ToString("X2");
}

private void UpdateMemory(int addr, int value)
{
	// Updates memory at the given address with the value, formatting as 2-digit hex
	mem[(addr / 16) + 1, (addr % 16) + 1].Text = value.ToString("X2");
}

private void UpdateSpecialRegister(string regName, int value)
{
	// Updates a special register (PC, IR) with the value, formatted as a 2-digit hexadecimal
	for (int i = 0; i < 2; i++)
	{
		if (spRegs[i, 0].Text.StartsWith(regName))
		{
			spRegs[i, 1].Text = value.ToString("X2");
			break;
		}
	}
}

	private void ExecuteSingleStep()
{
	// Assuming each instruction consists of two bytes
	int pc = Convert.ToInt32(spRegs[0, 1].Text, 16);
	string instruction = mem[(pc / 16) + 1, (pc % 16) + 1].Text + mem[(pc / 16) + 1, ((pc % 16) + 2) - 1].Text;
	int opcode = Convert.ToInt32(instruction.Substring(0, 1), 16);
	int reg, addr, val, val2;

	pc += 2; // Move PC past the instruction just fetched
	UpdateSpecialRegister("PC", pc % 256); // Ensure PC wraps correctly

	switch (opcode)
	{
		case 1: // Load
			reg = Convert.ToInt32(instruction.Substring(1, 1), 16);
			addr = Convert.ToInt32(instruction.Substring(2, 2), 16);
			UpdateRegister(reg, Convert.ToInt32(mem[(addr / 16) + 1, (addr % 16) + 1].Text, 16));
			break;
		case 2: // Load Immediate
			// Similar implementation to 'Load', but directly places a value into the register
			break;
		// Implement other opcodes similarly
		case 0xC: // Halt
			running = false;
			break;
		default:
			GD.PrintErr("Unsupported opcode: " + opcode);
			running = false;
			break;
	}
}

	private void ShowHelp()
{
	// Show help information in a dialog or output to console
	string helpString = "The machine is programmed by means of the data input window.\n\n" +
						"The syntax follows these examples:\n" +
						"  [PC] 80            Sets the program counter to 80 (hex).\n" +
						"  [R7] 23            Sets the contents of register 7 to 23 (hex).\n" +
						"  [30] 40 56 C0 00   Sets the contents of memory starting\n" +
						"                     at 30 (hex) to the values 40, 56, C0, 00.\n\n" +
						"The syntax is free format. For example, \n" +
						"         [PC] \n" +
						"         00 [00] 20 FF\n" +
						"         40 02 C0 00 \n" +
						"sets the program counter and memory cells. \n\n" +
						"Once changes have been entered into the data input window\n" +
						"   they can be transferred into the machine by clicking the\n" +
						"   Load Data button.\n\n" +
						"Programs can be placed in the data input window or saved from \n" +
						"   the data input window by copying (highlight text and then \n" +
						"   type Ctrl-C) and pasting (Ctrl-V) from or to a text file.\n";
	PopupPanel popup = GetNode<PopupPanel>("PopupPanel"); // Assuming the PopupPanel node is named "PopupPanel"
	Label helpLabel = popup.GetNode<Label>("Label");
	helpLabel.Text = helpString;
	popup.PopupCentered(); // Show the popup panel centered on the screen
}
}
