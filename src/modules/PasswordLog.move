address 0x471c1414C38f143B79bf41dDD9DD53dC {
    module PasswrodLog{

        use 0x1::Signer;
        use 0x1::Vector;
        
        public fun write (account:&signer,name:&vector<u8>,details:&vector<u8>) acquires Logs {
            let addr = Signer::address_of(account);
            let logs = borrow_global_mut<Logs>(addr);
            let list = *&mut logs.List;
            let log = Log {Name:*name,Details:*details };
            Vector::push_back<Log>(&mut list,log);  
        }
        struct Logs has key,store,copy,drop{
            List:   vector<Log>
        }
        struct Log has key,drop,store,copy{
            Name:      vector<u8>,
            Details:   vector<u8>,
        }

        public fun init(account:&signer)  {
            let addr = Signer::address_of(account);
            assert( ! exists<Logs> ( addr ) , 501 );
            move_to(account, Logs { List:Vector::empty<Log>()} );
        }
       

    }

    module PasswrodLog_Script{
        use 0x471c1414C38f143B79bf41dDD9DD53dC::PasswrodLog;
        public (script) fun init(account:signer){
            PasswrodLog::init(&account);
        }
        public (script) fun write(account:signer,name:vector<u8>,details:vector<u8>){
            PasswrodLog::write(&account,&name,&details);
        }
    }

}