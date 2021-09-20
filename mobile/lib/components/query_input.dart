import 'package:flutter/material.dart';
import 'package:mobile/screens/loading_page.dart';

class QueryInput extends StatefulWidget {
  final Function addToRecent;
  const QueryInput(this.addToRecent, {Key? key}) : super(key: key);

  @override
  _QueryInputState createState() => _QueryInputState();
}

class _QueryInputState extends State<QueryInput> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        child: SizedBox(
          child: InkWell(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 20,
                right: 10,
              ),
              child: TextField(
                onChanged: (text) {
                  setState(() {});
                },
                onSubmitted: (text) => submit(text),
                decoration: InputDecoration(
                  hintText: "Type your query here",
                  border: InputBorder.none,
                  suffixIcon: RawMaterialButton(
                    onPressed: () => submit(_textEditingController.text),
                    child: const Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                  ),
                ),
                controller: _textEditingController,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void submit(String text) {
    if (text != '') {
      widget.addToRecent(text);
      _textEditingController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingPage(text),
        ),
      );
    }
  }
}
