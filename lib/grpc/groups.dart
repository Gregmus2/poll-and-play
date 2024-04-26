import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:grpc/grpc.dart';
import 'package:poll_and_play/grpc/authenticator.dart';
import 'package:poll_play_proto_gen/google/protobuf/empty.pb.dart';
import 'package:poll_play_proto_gen/public.dart';

class GroupsClient {
  late GroupsServiceClient _client;

  GroupsClient(ClientChannel channel) {
    _client = GroupsServiceClient(channel);
  }

  Future<List<Group>> listGroups() async {
    try {
      final response = await _client.listGroups(Empty(), options: CallOptions(providers: [Authenticator.authenticate]));
      return response.groups;
    } catch (e) {
      // todo handle properly
      print('Error listing groups: $e');
      return [];
    }
  }

  Future<void> createGroup(String name) async {
    try {
      await _client.createGroup(CreateGroupRequest(name: name),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error creating group: $e');
    }
  }

  Future<void> updateGroup($fixnum.Int64 id, String name) async {
    try {
      await _client.updateGroup(UpdateGroupRequest(id: id, name: name),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error updating group: $e');
    }
  }

  Future<void> deleteGroup($fixnum.Int64 id) async {
    try {
      await _client.deleteGroup(DeleteGroupRequest(id: id),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error deleting group: $e');
    }
  }

  Future<void> inviteToGroup($fixnum.Int64 groupId, $fixnum.Int64 userId) async {
    try {
      await _client.inviteToGroup(InviteToGroupRequest(groupId: groupId, userId: userId),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error inviting to group: $e');
    }
  }

  Future<void> joinGroup($fixnum.Int64 id) async {
    try {
      await _client.joinGroup(JoinGroupRequest(groupId: id),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error joining group: $e');
    }
  }

  Future<void> removeUserFromGroup($fixnum.Int64 groupId, $fixnum.Int64 userId) async {
    try {
      await _client.removeFromGroup(RemoveFromGroupRequest(groupId: groupId, userId: userId),
          options: CallOptions(providers: [Authenticator.authenticate]));
    } catch (e) {
      // todo handle properly
      print('Error removing user from group: $e');
    }
  }

  Future<Group> getGroup($fixnum.Int64 id) async {
    try {
      final response = await _client.getGroup(GetGroupRequest(id: id),
          options: CallOptions(providers: [Authenticator.authenticate]));
      return response;
    } catch (e) {
      // todo handle properly
      print('Error getting group: $e');
      return Group();
    }
  }

  Future<List<User>> searchMembers($fixnum.Int64 groupId, String username) async {
    SearchFriendsToInviteRequest request = SearchFriendsToInviteRequest(groupExcluded: groupId, username: username);
    try {
      final response = await _client.searchFriendsToInvite(request, options: CallOptions(providers: [Authenticator.authenticate]));

      return response.users;
    } catch (e) {
      // todo handle properly
      print('Error searching members: $e');
      return [];
    }
  }
}
