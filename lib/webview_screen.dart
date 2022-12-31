import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({super.key});

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  InAppWebViewController? webViewController;
  PullToRefreshController? refreshController;
  var initialUrl = 'https://www.google.com/';
  late var url;
  double progress = 0;
  var urlController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    refreshController = PullToRefreshController(
        onRefresh: () {
          webViewController!.reload();
        },
        options: PullToRefreshOptions(color: Colors.deepOrange));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              if (await webViewController!.canGoBack()) {
                webViewController!.goBack();
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: TextField(
            onSubmitted: (value) {
              url = Uri.parse(value);
              if (url.scheme.isEmpty) {
                url = Uri.parse("${initialUrl}search?q=$value");
              }
              webViewController!.loadUrl(urlRequest: URLRequest(url: url));
            },
            controller: urlController,
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
                hintText: 'Search any things ',
                prefixIcon: Icon(Icons.search_rounded)),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                webViewController!.reload();
              },
              icon: const Icon(Icons.refresh_rounded))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Stack(
            alignment: Alignment.center,
            children: [
              InAppWebView(
                onWebViewCreated: ((controller) =>
                    webViewController = controller),
                initialUrlRequest: URLRequest(
                  url: Uri.parse(initialUrl),
                ),
                pullToRefreshController: refreshController,
                onLoadStart: (controller, url) {
                  setState(() {
                    isLoading = true;
                  });
                },
                onLoadStop: (controller, url) {
                  refreshController!.endRefreshing();
                  setState(() {
                    isLoading = false;
                  });
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    refreshController!.endRefreshing();
                  }
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
              Visibility(
                  visible: isLoading,
                  child: CircularProgressIndicator(
                    value: progress,
                    valueColor: const AlwaysStoppedAnimation(Colors.deepOrange),
                  ))
            ],
          )),
        ],
      ),
    );
  }
}
