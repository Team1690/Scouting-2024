import "dart:typed_data";

import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:graphql/client.dart";
import "package:progress_state_button/iconed_button.dart";
import "package:progress_state_button/progress_button.dart";
import "package:scouting_frontend/net/hasura_helper.dart";
import "package:scouting_frontend/views/mobile/hasura_vars.dart";

class FireBaseSubmitButton extends StatefulWidget {
  FireBaseSubmitButton({
    required this.vars,
    required this.mutation,
    required this.getResult,
    required this.resetForm,
    required this.validate,
    required this.filePath,
  });
  final HasuraVars vars;
  final String mutation;
  final bool Function() validate;
  final void Function() resetForm;
  final Future<Uint8List?> Function() getResult;
  final String filePath;

  @override
  State<FireBaseSubmitButton> createState() => _FireBaseSubmitButtonState();
}

class T {}

class _FireBaseSubmitButtonState extends State<FireBaseSubmitButton> {
  ButtonState _state = ButtonState.idle;
  String errorMessage = "";
  String graphqlErrorMessage = "";

  @override
  Widget build(final BuildContext context) => ProgressButton.icon(
        iconedButtons: <ButtonState, IconedButton>{
          ButtonState.idle: IconedButton(
            text: "Submit",
            icon: const Icon(Icons.send, color: Colors.white),
            color: Colors.blue[400]!,
          ),
          ButtonState.loading: IconedButton(
            text: "Loading",
            color: Colors.blue[400]!,
          ),
          ButtonState.fail: IconedButton(
            text: errorMessage,
            icon: const Icon(Icons.cancel, color: Colors.white),
            color: Colors.red.shade300,
          ),
          ButtonState.success: IconedButton(
            text: "Success",
            icon: const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            color: Colors.green.shade400,
          ),
        },
        state: _state,
        onPressed: () {
          if (_state == ButtonState.loading) return;

          if (_state == ButtonState.fail) {
            setState(() {
              _state = ButtonState.idle;
            });

            Navigator.push(
              context,
              MaterialPageRoute<Scaffold>(
                builder: (final BuildContext context) => Scaffold(
                  appBar: AppBar(
                    title: const Text("Error message"),
                  ),
                  body: Center(
                    child: Text(graphqlErrorMessage),
                  ),
                ),
              ),
            );
            return;
          }

          if (!widget.validate()) {
            setState(() {
              errorMessage = "Input Error";
              _state = ButtonState.fail;
            });

            Future<void>.delayed(
              const Duration(seconds: 5),
              () => setState((() => _state = ButtonState.idle)),
            );
            return;
          } else {
            uploadData();
            Future<void>.delayed(
              const Duration(seconds: 5),
              () => setState((() => _state = ButtonState.idle)),
            );
          }
        },
      );

  void uploadData() async {
    if (await widget.getResult() != null) {
      final Reference ref = FirebaseStorage.instance.ref(widget.filePath);

      final UploadTask firebaseTask = ref.putData(
        await widget.getResult() ??
            (throw Exception("can't happen but good to check :D")),
      );

      bool running = true;

      firebaseTask.snapshotEvents.listen((final TaskSnapshot event) async {
        if (event.state == TaskState.running && running) {
          setState(() {
            _state = ButtonState.loading;
          });
          running = false;
        } else if (event.state == TaskState.success) {
          final Map<String, dynamic> vars =
              Map<String, dynamic>.from(widget.vars.toJson());
          final String url = await ref.getDownloadURL();
          vars[
              widget.filePath.substring(widget.filePath.lastIndexOf(".") + 1) ==
                      "txt"
                  ? "path_url"
                  : "url"] = url;
          await submitToDb(vars, ref);
        } else if (event.state == TaskState.error) {
          setState(() {
            _state = ButtonState.fail;
            errorMessage = "error";
            graphqlErrorMessage = "Firebase error";
            Future<void>.delayed(
              const Duration(seconds: 5),
              () => setState((() => _state = ButtonState.idle)),
            );
          });
        }
      });
    } else {
      setState(() {
        _state = ButtonState.fail;
        errorMessage = "error";
        graphqlErrorMessage = "Invalid file";
        Future<void>.delayed(
          const Duration(seconds: 5),
          () => setState((() => _state = ButtonState.idle)),
        );
      });
    }
  }

  Future<void> submitToDb(
    final Map<String, dynamic> vars,
    final Reference? ref,
  ) async {
    final GraphQLClient client = getClient();

    final QueryResult<void> graphqlQueryResult = await client.mutate(
      MutationOptions<void>(
        document: gql(widget.mutation),
        variables: vars,
      ),
    );

    if (graphqlQueryResult.hasException) {
      if (ref != null) await ref.delete();
      setState(() {
        _state = ButtonState.fail;
        errorMessage = "Error";
      });

      graphqlErrorMessage = graphqlQueryResult.exception.toString();

      Future<void>.delayed(
        const Duration(seconds: 5),
        () => setState((() => _state = ButtonState.idle)),
      );
    } else {
      widget.resetForm();
      setState(() {
        _state = ButtonState.success;
      });
      Future<void>.delayed(
        const Duration(seconds: 5),
        () => setState((() => _state = ButtonState.idle)),
      );
    }
  }
}
