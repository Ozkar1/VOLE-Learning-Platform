using Godot;
using System;

public class Simulator : Control
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
		//TODO
		
		/*for (int i = 0; i < 17; i++)
		{
			for (int j = 0; j < 16; j++)
			{
				Label label = new Label();
				label.Text = "00"; // Default text for memory label
				mem[i, j] = label;
				memoryGridContainer.AddChild(label);
				//GD.Print("Label added at position: ", i, ",", j);
			}
		}*/

		//Forsøg 2
		for (int i = 0; i < 17; i++)
		{
			mem[i, 0] = new Label();
			mem[i, 0].Text = ToHex(i - 1, 1);
			mem[i, 0].Align = Label.AlignEnum.Center;
			memoryGridContainer.AddChild(mem[i, 0]); // Add the label to the scene tree
			
			for (int j = 1; j < 17; j++)
			{
				mem[i, j] = new Label();
				if (i == 0)
				{
					mem[i, j].Text = " " + ToHex(j - 1, 1);
				}
				else
				{
					mem[i, j].Text = "00";
				}
				
				mem[i, j].Align = Label.AlignEnum.Center; // Assuming you want all text centered
				memoryGridContainer.AddChild(mem[i, j]); // Add the label to the scene tree
			}
		}
		// special case
		mem[0,0].Text = "";
	
		// Get references to labels in the CPU panel
		GridContainer cpuPanel = GetNode<GridContainer>("CPUPanel");


// Initialize registers R1-R9 and RA-RF 
for (int i = 0; i < 16; i++) 
{
	Label regLabel = new Label();
	Label regValueLabel = new Label();

	
	if (i < 9) // Handles R1-R9
	{
		regLabel.Text = $"R{i + 1}"; 
		regValueLabel.Text = "00";
	}
	else // Handles RA-RF
	{
		char suffix = (char)('A' + (i - 9)); 
		regLabel.Text = $"R{suffix}";
		regValueLabel.Text = "00";
	}

	// Assign labels to the array
	regs[i, 0] = regLabel;
	regs[i, 1] = regValueLabel;

	// Add labels to the cpuPanel
	cpuPanel.AddChild(regLabel);
	cpuPanel.AddChild(regValueLabel);
}
	
	// Add special purpose registers
	string[] spRegNames = { "PC", "IR" };
	for (int i = 0; i < 2; i++)
	{
		Label spRegLabel = new Label();
		spRegLabel.Text = spRegNames[i]; 
		spRegs[i, 0] = spRegLabel;
		cpuPanel.AddChild(spRegLabel);

		Label spRegValueLabel = new Label();
		spRegValueLabel.Text = "00"; 
		if (i == 1){
			spRegValueLabel.Text = "0000"; 
		}
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


	private string ToHex(int val, int width)
	{
		// Return a string of at least width chars holding
		// the hex representation of the non-negative val.
		
		string hex = val.ToString("X").ToUpper(); // Convert to hex and make uppercase
		return hex.PadLeft(width, '0'); // Pad with '0' to ensure minimum width
	}
	
	// Her stopper UI implementation
	private void ClearMemory()
{
	for (int i = 1; i < 17; i++)
	{
		for (int j = 1; j < 17; j++)
		{
			mem[i, j].Text = "00";
		}
	}
	/*for (int i = 0; i < 17; i++)
	{ 
		//mem[i,0].Text =(i-1).ToString();
		mem[i,0].Text = "skrrt";
		
		for (int j = 1; j < 17; j++)
		{
			if(i == 0){
				mem[i, j].Text = " ";
			} else if(j > 0) {
				mem[i, j].Text = "00";
				}
			
		}
	}*/
}
private void LoadData()
{
	
	// Clear registers and memory
	for (int i = 0; i < 16; i++)
		regs[i, 1].Text = "00";
	spRegs[0, 1].Text = "00";
	spRegs[1, 1].Text = "0000";
	for (int i = 1; i < 17; i++)
		for (int j = 1; j < 17; j++)
			mem[i, j].Text = "00";

	string input = inArea.Text;
	int address = 0;
	int rNum = 0;
	bool chgReg = false, chgMem = false, chgPC = false;

	

	try
	{
		int ptr = 0;
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
				ptr++; // Move past '['
				c = input[ptr]; // Look at the next character

				if (c == 'R' || c == 'r')
				{
					if (int.TryParse(input.Substring(ptr + 1, 1), System.Globalization.NumberStyles.HexNumber, null, out rNum))
					{
						chgReg = true; chgMem = false; chgPC = false;
					}
				}
				else if (c == 'P' || c == 'p')
				{
					chgPC = true; chgMem = false; chgReg = false;
				}
				else
				{
					if (int.TryParse(input.Substring(ptr, 2), System.Globalization.NumberStyles.HexNumber, null, out address))
					{
						chgMem = true; chgPC = false; chgReg = false;
					}
				}
				ptr += 3; // Move past the processed characters
			}
			else
			{
				if (int.TryParse(input.Substring(ptr, 2), System.Globalization.NumberStyles.HexNumber, null, out int val))
				{
					if (chgPC) spRegs[0, 1].Text = val.ToString("X2");
					if (chgReg) regs[rNum, 1].Text = val.ToString("X2");
					if (chgMem)
					{
						mem[address / 16 + 1, address % 16 + 1].Text = val.ToString("X2");
						address++;
					}
				}
				ptr += 2; // Move past the hex value
			}
		}
	}
	catch (Exception ex)
	{
		GD.Print("Error loading data: ", ex.Message);
		
	}
}

private void RunProgram()
{
	running = true;
	while (running)
	{
		ExecuteSingleStep();
		// Optionally, add a small delay here
	}
}

private void ExecuteSingleStep()
{
	// Get current program counter
	int loc = Convert.ToInt32(spRegs[0, 1].Text, 16);
	if (loc < 0 || loc > 0xFE)
	{
		GD.Print("Illegal instruction address");
		running = false;
		return;
	}
	
	// Fetch instruction
	string byte1 = mem[loc / 16 + 1, loc % 16 + 1].Text;
	loc++;
	loc &= 0xFF;
	string byte2 = mem[loc / 16 + 1, loc % 16 + 1].Text;
	loc++;
	loc &= 0xFF;
	spRegs[1, 1].Text = byte1 + byte2;
	
	// Reset PC
	spRegs[0, 1].Text = loc.ToString("X2");

	int opcode = Convert.ToInt32(byte1.Substring(0, 1), 16);
	switch (opcode)
	{
		case 1: // Load
			{
				int reg = Convert.ToInt32(byte1.Substring(1, 1), 16);
				int address = Convert.ToInt32(byte2, 16);
				regs[reg, 1].Text = mem[address / 16 + 1, address % 16 + 1].Text;
				break;
			}
		case 2: // Load Immediate
			{
				int reg = Convert.ToInt32(byte1.Substring(1, 1), 16);
				regs[reg, 1].Text = byte2;
				break;
			}
		case 3: // Store
			{
				int reg = Convert.ToInt32(byte1.Substring(1, 1), 16);
				int address = Convert.ToInt32(byte2, 16);
				mem[address / 16 + 1, address % 16 + 1].Text = regs[reg, 1].Text;
				break;
			}
		case 4: // Reg move
			{
				int srcReg = Convert.ToInt32(byte2.Substring(0, 1), 16);
				int destReg = Convert.ToInt32(byte2.Substring(1, 2), 16);
				regs[destReg, 1].Text = regs[srcReg, 1].Text;
				break;
			}
		// Additional cases for other opcodes...
		case 0xC: // Halt
			running = false;
			break;
		default:
			GD.Print("Unexpected opcode=" + opcode);
			running = false;
			break;
	}
}

private void ShowHelp()
{
	// Show help dialog popup
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
	PopupPanel popup = GetNode<PopupPanel>("PopupPanel"); 
	Label helpLabel = popup.GetNode<Label>("Label");
	helpLabel.Text = helpString;
	popup.PopupCentered(); 
}
	
}
