/*
 * A converter from JavaScript AST to S-expression.
 * The JS AST is in JSON format and it is converted to a textual output
 * in a Scheme-`read'able S-expression.
 */

var util = require('util');
var fs = require('fs');

var SX_STYLE_ALIST = 'SX Style Alist';
var SX_STYLE_SIMPLE = 'SX Style Simple';
var sx_style = SX_STYLE_SIMPLE;

var ast = {};
fs.readFileSync('ast.spec', 'utf8').split('\n').forEach(function (line) {
    var spec = line.split(': ');
    if (spec.length === 1) return;
    var type = spec[0], keys = spec[1].split(', ');
    keys.splice(0, 0, 'type');
    ast[type] = keys;
  });

var literal_re = new RegExp('^(.*Literal|This)$');
var property_re = new RegExp('^Property.*|[GS]etterDefinition$');

function sx_string(s) { return '"' + s + '"'; }

var literal_table = [], literal_id = 0;
function literal(l) {
  literal_table.push(l);
  return sx_string(util.format('L-%d', literal_id++));
}

function enclose(tag, l) {
  l = ax(l);
  l.splice(0, 0, tag);
  return l;
}

function ax(t) {
  if (!t) throw (new Error({ message: 'Invalid AST node: ', t: t }));
  if (typeof t === 'string') return literal(t);
  if (Array.isArray(t)) return t.map(ax);

  var spec = ast[t.type];
  if (literal_re.exec(t.type)) return literal(t);

  switch (t.type) {
  case 'Variable': return util.format('V-%s', t.name);
  case 'VariableStatement': return enclose('begin', t.declarations);
  case 'VariableDeclaration':
    return ['define', 'V-' + t.name, ax(t.value)];
  case 'CatchStatement':
    throw (new Error({ message: 'Not implemented yet: ', t: t }));
  case 'Program': return enclose('begin', t.elements);
  default:
    return spec.map(function (f, i) {
        switch (sx_style) {
        case SX_STYLE_ALIST:
          return i === 0 ? util.format('"%s"', t[f]) : [ sx_string(f), ax(t[f]) ];
        case SX_STYLE_SIMPLE:
          return i === 0 ? util.format('"%s"', t[f]) : ax(t[f]);
        }
      });
  }
}

function sx(t) {
  if (Array.isArray(t)) return '(' + t.map(sx).join(' ') + ')';
  return t;
}

exports.convert = function (t, output) {
  var fd = typeof output === 'number' ? output :
  typeof output === 'string' ? fs.openSync(output, 'w') : false;

  var s = sx(ax(t));
  if (fd) {
    fs.writeSync(fd, s, 0, s.length, null);
    fs.closeSync(fd);
  }
  return s;
};
