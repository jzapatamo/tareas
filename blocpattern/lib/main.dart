import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Eventos del Bloc
abstract class QuoteEvent {}
class FetchQuote extends QuoteEvent {}
class ResetQuote extends QuoteEvent {}

// Estados del Bloc
abstract class QuoteState {}
class QuoteInitial extends QuoteState {}
class QuoteLoading extends QuoteState {}
class QuoteLoaded extends QuoteState {
  final String quote;
  QuoteLoaded(this.quote);
}
class QuoteError extends QuoteState {}

// Bloc para manejar los estados
class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  QuoteBloc() : super(QuoteInitial()) {
    on<FetchQuote>(_onFetchQuote);
    on<ResetQuote>(_onResetQuote);
  }

  void _onFetchQuote(FetchQuote event, Emitter<QuoteState> emit) async {
    emit(QuoteLoading());
    try {
      final response = await http.get(Uri.parse('https://zenquotes.io/api/quotes'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        emit(QuoteLoaded(data[0]['q'] + " - " + data[0]['a']));
      } else {
        emit(QuoteError());
      }
    } catch (e) {
      emit(QuoteError());
    }
  }

  void _onResetQuote(ResetQuote event, Emitter<QuoteState> emit) {
    emit(QuoteInitial());
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => QuoteBloc(),
        child: QuoteScreen(),
      ),
    );
  }
}

class QuoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reseñas Inspiradoras")),
      body: Center(
        child: BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, state) {
            if (state is QuoteInitial) {
              return Text("Obtener una nueva reseña", style: TextStyle(fontSize: 20));
            } else if (state is QuoteLoading) {
              return CircularProgressIndicator();
            } else if (state is QuoteLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(state.quote, style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
              );
            } else {
              return Text("Error al obtener la reseña", style: TextStyle(color: Colors.red));
            }
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<QuoteBloc>().add(FetchQuote()),
            child: Icon(Icons.refresh),
            tooltip: "Obtener Reseña",
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => context.read<QuoteBloc>().add(ResetQuote()),
            child: Icon(Icons.clear),
            tooltip: "Reiniciar",
          ),
        ],
      ),
    );
  }
}