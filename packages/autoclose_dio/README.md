
# autoclose_dio

**autoclose_dio** is a subpackage of [autoclose](https://pub.dev/packages/autoclose) for automatic resource management in Dio-based HTTP clients. It helps you avoid manual cancellation and cleanup of Dio resources by integrating with the AutoClose ecosystem.

## What is this?

This package extends [autoclose](https://pub.dev/packages/autoclose) to support Dio. 

**Important:** The only function of this library is to automatically manage Dio's `CancelToken` for HTTP requests. Unlike other autoclose integrations (streams, subscriptions, etc.), where cancellation only stops awaiting a `Future`, cancelling a Dio `CancelToken` truly aborts the HTTP connection at the transport level. This means the request is interrupted immediately, not just ignored in Dart code.

This is especially useful for large or long-running requests: by cancelling the token, you prevent unnecessary network traffic and avoid extra computation on the client, such as parsing large JSON responses that are no longer needed.

## Before and After Example

Suppose you have a repository like this:

```dart
class BookWebApi {
	late Dio client;

	Future<BookArticleItem> getArticle({required String id}) async {
		final response = await client.get('/v1/book/articles/$id');
		return BookArticleItem.fromJson(response.data);
	}
}
```

With `autoclose_dio`, you can refactor it as follows:

```dart
import 'package:autoclose_dio/autoclose_dio.dart';

class BookWebApi {
	late Dio client;

	Future<BookArticleItem> getArticle({required String id, HasCloser? closeWith}) async {
		final response = await client.get(
			'/v1/book/articles/$id',
			cancelToken: closeWith?.getCancelToken(),
		);
		return BookArticleItem.fromJson(response.data);
	}
}
```

Now, in a context that implements `HasCloser` (for example, a Bloc or a Flutter stateful widget, `ChangeNotifier`), you can write:

```dart
final article = await bookApi.getArticle(id: aid, closeWith: this);
```

This ensures that the request will be automatically cancelled if the parent context (e.g., Bloc or Widget) is closed/disposed, preventing leaks and unnecessary network activity.

---

See the main [autoclose](https://pub.dev/packages/autoclose) package for more details and core concepts.
