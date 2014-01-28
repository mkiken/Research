Expression display {
    Expression s, punc, t;
    Keyword and;

    { display (punc) {s, ... and t} -> println([# s + punc + #] ... t ) }
}

object Display{
  def main(args: Array[String]): Unit = {
    (display(" -> "){"目黒", "不動前", "武蔵小山", "西小山", "洗足" and "大岡山"});
    (display(" --> "){"目黒", "武蔵小山" and "大岡山"});
  }
}
