# DYNAMIC INSTRUCTIONS CALCULATION

![project-img1.jpg](static/logo.jpg)

An open-source tool to find the frequency of different assembly instructions of an executable file to be executed. 

#&quot;Part of Diversion 2k23 Open-source Event&quot;
<p align="center">
    <a href="https://diversion.tech/">
        <img src="https://github.com/acm-iem/Readme-template/blob/main/Logos/Diversion%20Full%20Logo%20White.png" width="30%">
    </a>
</p>



# Requirements :

- Linux Environment
- Python
- gdb
- flask framework  (Only needed if you want to use it in a GUI web app.)

# Usage :

You can use this application in 2 ways. One of the ways is through the command line and the other way is through a web application that will be hosted on your local machine or using the website [https://instructions.pythonanywhere.com/](https://instructions.pythonanywhere.com/)

## 1st Way (Using Terminal):

1. Clone the repository.

```cpp
git clone git@github.com:AyushR1/Dynamic-Instructions-Calculation.git
```

1. (1st Way) Running the script in terminal

```cpp
./dic.sh <compiled_file>
./dic.sh <compiled_file> <input_file> 
(If your application requires input, make a file which will contain the input 
and pass the filename as argument)
```

1. The analysis of the executable will be printed in the terminal.
2. Please be patient as it takes a about 50-60 seconds, it also depends on how fast the  processing of your PC is.

## 2nd Way (Using The Web App) :

1. Deploy the web application.

```cpp
python app.py
```

1. Visit the URL which will be printed in the terminal, or you can also visit http://localhost:5000 or http://127.0.0.1:5000
2. Select the binary file which you want to analyze and click the submit button.
3. In a few minutes the analysis will be ready.


# To-Dos
Create a text input field/input file upload on the web app for users to enter inputs of their program.
The existing script ahs support for text input. Just implemnt a frontend for the same
Test the script with the new text input feature to ensure it works as expected

Expose an API for the same, provide clear instructions for how to use it





# Using Rest API Documentation:

[How to use API for instructions of your program](docs/api.md)
