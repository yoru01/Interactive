"reach 0.1";

export const main = Reach.App(() => {
  setOptions({ untrustworthyMaps: true });
  const Deployer = Participant('Deployer', {
    ready: Fun([], Null),
    seeStatusP: Fun([Address], Null),
    seeStatusD: Fun([Address], Null),
  });

  const Bobs = API('Bobs', {
    addUsers: Fun([], Bool ),
  });

  init();

 Deployer.only(() => {
    interact.ready();
   
  });
  Deployer.publish();
  const users1 = new Set();
    commit(); 
  Deployer.publish();
  const [users] =
    parallelReduce([1])
    .invariant(balance() == 0)
    .while( users > 0 )
    .api_(Bobs.addUsers, () => {
      //check( this != Deployer)
      return [ 0, (k) => {
        if(users <= 5){
          k(true);
          users1.insert(this);
          Deployer.interact.seeStatusP(this);
        }
        else{
          k(false);
          Deployer.interact.seeStatusD(this);
        }
        return [ users + 1];
      }];
    })
  commit();
  exit();
});
