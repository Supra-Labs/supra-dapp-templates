#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const inquirer = require('inquirer');

// ASCII Art for SUPRA
const supraArt = `

███████╗██╗   ██╗██████╗ ██████╗  █████╗ 
██╔════╝██║   ██║██╔══██╗██╔══██╗██╔══██╗
███████╗██║   ██║██████╔╝██████╔╝███████║
╚════██║██║   ██║██╔═══╝ ██╔══██╗██╔══██║
███████║╚██████╔╝██║     ██║  ██║██║  ██║
╚══════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝

`;

const templatesDir = path.join(__dirname, 'templates');

async function init() {
  console.log(supraArt);
  console.log('Welcome to the Supra dApp Templates Wizard 🌐');

  let templates;
  try {
    templates = fs.readdirSync(templatesDir).map(dir => ({
      name: dir,
      value: dir
    }));
    
    if (templates.length === 0) {
      console.error('\nError: No templates found in templates directory.\n');
      process.exit(1);
    }
  } catch (error) {
    console.error(`\nError reading templates: ${error.message}\n`);
    process.exit(1);
  }

  const answers = await inquirer.prompt([
    {
      type: 'input',
      name: 'projectName',
      message: 'Enter the Name of Your Project:',
      default: 'supra-dapp',
      validate: (input) => {
        if (!input || input.trim() === '') {
          return 'Project name cannot be empty';
        }
        if (!/^[a-zA-Z0-9-_]+$/.test(input)) {
          return 'Project name can only contain letters, numbers, hyphens, and underscores';
        }
        return true;
      }
    },
    {
      type: 'list',
      name: 'template',
      message: 'Choose how to start:',
      choices: templates
    }
  ]);

  const templatePath = path.join(templatesDir, answers.template);
  const projectPath = path.join(process.cwd(), answers.projectName);

  if (fs.existsSync(projectPath)) {
    console.error(`\nError: Directory '${answers.projectName}' already exists.`);
    console.log('Please choose a different project name or remove the existing directory.\n');
    process.exit(1);
  }

  try {
    fs.mkdirSync(projectPath);
    fs.cpSync(templatePath, projectPath, { recursive: true });

    console.log(`Project ${answers.projectName} created successfully!`);
    console.log(`\nPlease read the README file in the selected template directory for documentation.\nFor support and additional information, visit the Supra Developer Hub: https://github.com/Entropy-Foundation/supra-dev-hub`);
  } catch (error) {
    console.error(`\nError creating project: ${error.message}\n`);
    if (fs.existsSync(projectPath)) {
      try {
        fs.rmSync(projectPath, { recursive: true, force: true });
      } catch (cleanupError) {
      }
    }
    process.exit(1);
  }
}

init();
