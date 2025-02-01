#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const inquirer = require('inquirer');

// ASCII Art for SUPRA
const supraArt = `

 #######   #    #   ######  ######    ######            #          ##   
 #     #   #    #   #    #  #    #    #    #            #          ##   
 #         #    #   #    #  #    #    #    #            #          ##   
 #######  ##    #  #######  #######  #######           ##          ##   
      ##  ##    #  ##       ##    #  ##    #           ##          ##   
 #    ##  ##    #  ##       ##    #  ##    #           ##          ##   
 #######  #######  ##       ##    #  ##    #           #######     ##   
                                                                        
`;

const templatesDir = path.join(__dirname, 'templates');

async function init() {
  console.log(supraArt);
  console.log('Welcome to the supra-dapp-templates wizard 🌐');

  const templates = fs.readdirSync(templatesDir).map(dir => ({
    name: dir,
    value: dir
  }));

  const answers = await inquirer.prompt([
    {
      type: 'input',
      name: 'projectName',
      message: 'Enter a new project name:',
      default: 'my-supra-dapp'
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

  fs.mkdirSync(projectPath);
  fs.cpSync(templatePath, projectPath, { recursive: true });

  console.log(`Project ${answers.projectName} created successfully!`);
  console.log(`\nPlease read the README file in the selected template directory for documentation.\nFor support and additional information, visit the Supra Developer Hub: []https://github.com/Entropy-Foundation/supra-dev-hub`);
}

init();
