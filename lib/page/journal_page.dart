import "package:crud_apps/models/journals.dart";
import "package:crud_apps/repositories/journal_repository.dart";
import "package:crud_apps/widget/journal_form_widget.dart";
import "package:flutter/material.dart";


class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class HeaderClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width * 0.6, size.height - 60,
      size.width, size.height - 40,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const cut = 20.0;
    final path = Path();
    path.moveTo(16, 0);
    path.lineTo(size.width - cut, 0);
    path.lineTo(size.width, cut);
    path.lineTo(size.width, size.height - 16);
    path.quadraticBezierTo(size.width, size.height, size.width - 16, size.height);
    path.lineTo(16, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - 16);
    path.lineTo(0, 16);
    path.quadraticBezierTo(0, 0, 16, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: HeaderClipper(),
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 16),
                  child: Text(
                    'Journal Apps',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // List journal
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: journals.length,
              itemBuilder: (context, index) {
                final journal = journals[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ClipPath(
                    clipper: CardClipper(),
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        tileColor: Colors.blue.shade50,
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
                        onTap: () {
                          _showJournalFormDialog(journals: journal);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Delete Entry"),
                                  content: const Text(
                                      "Are you sure you want to delete this entry ?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deleteJournals(journal.id!);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showJournalFormDialog();
        },
      ),
    );
  }
}

