from flask import Flask, request
from mecab import MeCab
from g2pk import G2p

app = Flask(__name__)


mecab = MeCab(dictionary_path='/usr/local/lib/mecab/dic/mecab-ko-dic')  
g2p = G2p()


@app.route('/')
def hello_world():
    return {'result': 'hello world!'}


@app.route('/mecab')
def get_mecab():
    k_str = request.args.get('q', '')
    if not k_str:
        return {'morphemes': []}
    result = mecab.parse(k_str)

    morphemes = [
        {
            'surface': m.surface, 
            'pos': m.feature.pos,
            'start_offset': m.span.start,
            'end_offset': m.span.end
        }     
        for m in result
    ]

    return {'morphemes': morphemes}


@app.route('/g2pk')
def run_g2pk():
    k_str = request.args.get('q', '')
    res, rules = g2p(k_str, verbose=True)
    return {
        'result': res, 
        'rules': rules
    }
