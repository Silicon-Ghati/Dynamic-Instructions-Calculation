
#!/usr/bin/python3

from flask import Flask, render_template, request
from werkzeug.utils import secure_filename
import subprocess
import shlex

app = Flask(__name__)

app.config["UPLOAD_FOLDER"] = "/home/instructions/dic/static/dic_temp_files/"

@app.route('/')
def upload_file():
    return render_template('index.html')


@app.route('/display', methods = ['GET', 'POST'])
def save_file():
    if request.method == 'POST':
        f = request.files['file']
        global filename
        filename = secure_filename(f.filename)

        f.save(app.config['UPLOAD_FOLDER'] + filename)
        subprocess.call(shlex.split('bash /home/instructions/dic/dic.sh ' + app.config['UPLOAD_FOLDER'] + str(filename)))
    
    return render_template('contenthome.html')

@app.route('/analysis')
def analysis():
    ana = open(app.config['UPLOAD_FOLDER'] + filename + '_analysis',"r")
    contentana = ana.read()
    return render_template('content.html', content=contentana)

@app.route('/ins')
def ins():
    ins = open(app.config['UPLOAD_FOLDER'] + filename + '_ins',"r")
    content = ins.read()
    return render_template('content.html', content=content)

@app.route('/chart')
def chart():
   chart = open(app.config['UPLOAD_FOLDER'] + filename + '_chart',"r")
   contentchart = chart.read()
   return contentchart

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug = True)
