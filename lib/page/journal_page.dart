import "package:crud_apps/models/journals.dart";
import "package:crud_apps/repositories/journal_repository.dart";
import "package:crud_apps/widget/journal_form_widget.dart";
import "package:flutter/material.dart";


class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<Journals> journals = [];

  Future<void> loadJournals() async{
    try {
      final data = await JournalRepository.getListJournals();
      debugPrint('Jumlah data: ${data.length}');
      setState(() {
        journals = data;
      });
    } catch (e, st) {
      debugPrint('Error load journals: $e\n$st');
    }
  }

  @override
  void initState(){
    super.initState();
    loadJournals();
  }

  void _showJournalFormDialog({Journals? journals}) async{
    final title = journals == null ? "Add Journal" : "Update Journal";
    final result = await showDialog(
        context: context,
        builder: (_){
          return AlertDialog(
            title: Text(title),
            content: JournalFormWidget(journals: journals,),
          );
        }
    );
    if(result != null){
      await loadJournals();
    }
  }

  void _deleteJournals(int id) async{
    await JournalRepository.deleteJournals(id);
    await loadJournals();
  }

  void showDeleteDialogs(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Journal Apps',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          ),
        ),
        child: ListView.builder(
            itemCount: journals.length,
            itemBuilder: (context, index){
              final journal = journals[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      journal.title[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    journal.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(journal.description),
                  onTap: (){
                  _showJournalFormDialog(journals: journal);
                  },
                  trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red,),
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: const Text("Delete Entry"),
                                content: const Text("Are you sure you want to delete this entry ?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                      onPressed: (){
                                        _deleteJournals(journal.id!);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Delete")
                                  )
                                ],
                              );
                            }
                        );
                  },
                  ),
                ),
              );
            },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: (){
            _showJournalFormDialog();
          }
      ),
    );
  }
}

