import uuid

def getUUID():
    return uuid.uuid4().__str__()

if __name__ == '__main__':
    print getUUID();
