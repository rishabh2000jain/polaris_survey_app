# polaris_survey_app

Polaris Grid

## Project Setup Steps

1. Check your flutter version it should be Flutter 3.13.6 and Dart 3.1.3 or more.
2. flutter pub get
3. flutter pub run build_runner build --delete-conflicting-outputs
4. Add your aws keys in common/aws_common.dart
5. Execute step 2 and step 3 command this install all the dependencies and will generate all the
   required code that has to be generated.

## Project Architecture

  <ol>
        <li><h4>This project follows a mixture of clean architecture and BLoC pattern.</h4></li>
            <li><h4>All the features are placed into lib/features directory.</h4></li>
            <li><h4>Every feature has primarily these sub-directory</h4></li>

<ul>
    <li>
        <b>data</b>
        <ul>
            <li>mapper</li>
            <li>model</li>
            <li>repository implementation</li>
            <li>services</li>
        </ul>
    </li>
    <li> <b>domain</b>
        <ul>
            <li>entity</li>
            <li>repository abstract class</li>
            <li>use cases</li>
        </ul>
    </li>
    <li><b>presentation</b>
        <ul>
            <li>bloc/cubit/controller</li>
            <li>screen</li>
            <li>widgets</li>
        </ul></li>
</ul>
<li><h4>All the common widgets and models and other commons will be placed in lib/common directory. </h4></li>
<li><h4>All the services will be placed inside lib/core.</h4></li>

</ol>