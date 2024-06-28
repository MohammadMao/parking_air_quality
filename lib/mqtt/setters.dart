// ignore_for_file: avoid_print

double coval = 0;
bool doorval = false;
double smokeval = 0;
bool fanval = false;
bool fanMode = false;

void setSmoke(String smoke) {
  smokeval = double.parse(smoke);
  // print('this is string $smokeval');
}

void setCO(String co) {
  coval = double.parse(co);
  // print('this is string $co');
}

void setDoor(String door) {
  doorval = (door == 'open') ? true : false;
  // print(door);
}

void setFan(String fan) {
  fanval = (fan == 'not working') ? false : true;
  // print(fanval);
}

void setFanMode(String mode) {
  fanMode = (mode == '1') ? true : false;
}
