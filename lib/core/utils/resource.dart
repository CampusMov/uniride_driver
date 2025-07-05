abstract class Resource<T> {
  const Resource();
}

class Loading<T> extends Resource<T> {
  const Loading();
}

class Success<T> extends Resource<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Resource<T> {
  final String message;
  const Failure(this.message);
}