import 'package:expense_tracker/enums/category.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensesModal extends StatefulWidget {
  final void Function(Expense expense) addExpense;

  // edit related functionality
  final void Function(Expense expense, int id)? editExpense;
  final bool? update;
  final Expense? expense;
  final int? index;

  const ExpensesModal(
      {super.key,
      required this.addExpense,

      // edit related functionality
      this.expense,
      this.editExpense,
      this.update,
      this.index});

  @override
  State<ExpensesModal> createState() => _ExpensesModalState();
}

class _ExpensesModalState extends State<ExpensesModal> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String? _dateStr;
  DateTime? _dateTime;
  Category _category = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _close() {
    Navigator.pop(context);
  }

  void _showDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    if (pickedDate == null) return;

    // set the picked date
    setState(() {
      // update the string date format for our custom indicator
      _dateStr = DateFormat('MMMM d, y').format(pickedDate);
      _dateTime = pickedDate;
    });
  }

  void _submitExpense() {
    final enteredAmt = double.tryParse(_amountController.text);

    // check entered amount
    final amountInvalid = enteredAmt == null || enteredAmt <= 0;

    // check title
    final titleInvalid = _titleController.text.trim().isEmpty;

    // check date
    final dateInvalid = _dateStr == null;

    if (amountInvalid || titleInvalid || dateInvalid) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Incomplete'),
                content: Text(
                    'Please make sure a valid ${amountInvalid ? 'amount, ' : ''}${titleInvalid ? 'title, ' : ''}${dateInvalid ? 'date, ' : ''} was entered.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text('OK'))
                ],
              ));
      return;
    }

    // create an instance of expense
    var newExpense = Expense(
        id: widget.update == true ? widget.expense!.id : null,
        amount: enteredAmt,
        title: _titleController.text,
        date: _dateTime!,
        category: _category);

    // if we're on editing mode
    if (widget.update == true) {
      widget.editExpense!(newExpense, widget.index!);
    } else {
      // add our new expense to the state
      widget.addExpense(newExpense);
    }

    // dismiss this modal
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    // if update is set, then we must restore all the values to the appropriate input boxes
    if (widget.update == false) return;

    // restore title
    _titleController.text = widget.expense!.title;

    // restore amount
    _amountController.text = widget.expense!.amount.toString();

    // restore category
    _category = widget.expense!.category;

    // restore date
    _dateTime = widget.expense!.date;
    _dateStr = DateFormat('MMMM d, y').format(widget.expense!.date);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final orientation = MediaQuery.of(context).orientation;

    return LayoutBuilder(builder: (ctx, contraints) {
      // we wrap with SizedBox then set our height conditionally
      // if orientation is landscape, set height to double infinity to
      // make sure that it takes up all the available height on landscape
      // but default to the just enough space it needs on portrait mode.
      //
      // i want the UI elements to be as centered or close to our thumbs
      // see: https://developer.samsung.com/one-ui/largescreen-and-foldable/large_screen_layout.html
      // which was my inspiration lately in designing user interfaces.
      return SizedBox(
        height: orientation == Orientation.landscape ? double.infinity : null,
        // we wrap with singlechildscrollview so that on landscape mode
        // the user can still scroll the inputs up and down
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.only(
                  top: 20, bottom: 20 + keyboardSpace, left: 20, right: 20),
              child: Column(
                children: [
                  Center(
                    child: Text(
                        widget.update == true ? 'Edit Expense' : 'New Expense',
                        style: TextStyle(fontSize: 20)),
                  ),
                  orientation == Orientation.portrait
                      ? Column(
                          children: [
                            TextField(
                                controller: _titleController,
                                maxLength: 50,
                                decoration:
                                    InputDecoration(labelText: 'Title')),
                            Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Amount', prefixText: '₱ '),
                                )),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(_dateStr ??= 'Select a date'),
                                      IconButton(
                                          onPressed: _showDatePicker,
                                          icon: Icon(Icons.calendar_month))
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Category:',
                                    style: TextStyle(fontSize: 15)),
                                SizedBox(width: 30),
                                Expanded(
                                  child: DropdownButton(
                                    items: Category.values
                                        .map((category) => DropdownMenuItem(
                                            value: category,
                                            child: Text(
                                                category.name.toUpperCase())))
                                        .toList(),
                                    onChanged: (selected) {
                                      if (selected == null) return;
                                      setState(() {
                                        _category = selected;
                                      });
                                    },
                                    value: _category,
                                  ),
                                ),
                                SizedBox(width: 20)
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                    child: TextButton(
                                        onPressed: _close,
                                        child: Text('Cancel'))),
                                SizedBox(width: 10),
                                Expanded(
                                    child: ElevatedButton(
                                        onPressed: _submitExpense,
                                        child: Text('Save')))
                              ],
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    TextField(
                                        controller: _titleController,
                                        maxLength: 50,
                                        decoration:
                                            InputDecoration(labelText: 'Title'))
                                  ],
                                )),
                                SizedBox(width: 20),
                                Expanded(
                                    child: TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      labelText: 'Amount', prefixText: '₱ '),
                                ))
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                TextButton.icon(
                                    onPressed: _showDatePicker,
                                    icon: Icon(Icons.calendar_month),
                                    label: Text('Select a date')),
                                SizedBox(width: 20),
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Category:',
                                        style: TextStyle(fontSize: 15)),
                                    SizedBox(width: 20),
                                    DropdownButton(
                                      items: Category.values
                                          .map((category) => DropdownMenuItem(
                                              value: category,
                                              child: Text(
                                                  category.name.toUpperCase())))
                                          .toList(),
                                      onChanged: (selected) {
                                        if (selected == null) return;
                                        setState(() {
                                          _category = selected;
                                        });
                                      },
                                      value: _category,
                                    ),
                                  ],
                                )),
                                TextButton(
                                    onPressed: _close, child: Text('Cancel')),
                                SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: _submitExpense,
                                    child: Text('Save'))
                              ],
                            ),
                          ],
                        )
                ],
              )),
        ),
      );
    });
  }
}
